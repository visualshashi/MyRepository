/**
*
* @name                 : ErrorLogsUtils
* @author               : Happiest minds 
* @description          : This class is the utility class to handle error log details across the customization
* @created date         : 15-October-2020
*
**/
//This is code commit test from VSCode 
public class ErrorLogsUtils{
    
    /*****************************************************************************************************************************
     *
     * Gloabal Constants & Variables
     *
     *****************************************************************************************************************************/    
    public static String INFO = 'INFO';
    public static String WARNING = 'WARNING';
    public static String ERROR = 'ERROR';
    public static String FATAL = 'FATAL';
    
    
    /**
     * @description : Used to check the error logging service is Active or not 
     */
    @TestVisible private static Boolean isEnabled(){
        //get email service flag from custom settings
        SV_Utility_Settings__c enableLogging = SV_Utility_Settings__c.getOrgDefaults();
        System.debug('IsEnabled: ' + enableLogging.EnableCustomLogging__c);
        return enableLogging.EnableCustomLogging__c;
    }
    
    /**
     * @description : Used to create the error logs 
     * @param       : status            Error log status
     * @param       : className         Name of the class error was created 
     * @param       : methodName        Name of the method error was created 
     * @param       : errorMessage      Message about the error
     * @param       : errorDescription  Description about the error
     * @param       : recordID          Record ID fro which the error created
     * @param       : reqBody           HTTP request body or initial content for any request
     * @param       : resBody           HTTP response body or any content for any response
     * @param       : doNotDelete       Whether this record can be deleted or not
     * @param       : Priority          Error log record priority
     * @param       : sendEmail         Whether this record can be sent to email
     * @param       : emailSubject      Email subject
     * @param       : emailBody         Email content
     */
    public static void createErrorLogs(String status, String className, String methodName, String errorMessage, String errorDescription, String recordID, String reqBody, String resBody, Boolean doNotDelete, String Priority, Boolean sendEmail, String emailSubject, String emailBody ){
       //check the error log service is enabled or not 
        if(isEnabled()){
            
            try{
                //instantiating the error log object
                Error_Logs__c errorlog = new Error_Logs__c();
                errorlog.Status__c = status;
                errorlog.Class_Name__c = className;
                errorlog.Method_Name__c = methodName;
                errorlog.Error_Message__c = errorMessage;
                errorlog.Error_Description__c = errorDescription;
                errorlog.Record_ID__c = recordID;
                errorlog.Request_Body__c = reqBody;
                errorlog.Response_Body__c = resBody;
                errorlog.Logged_in_User__c = UserInfo.getName();
                errorlog.Do_Not_Delete__c = doNotDelete;
                errorlog.Priority__c = Priority;
                errorlog.Requested_Time__c = system.now();
                errorlog.Send_Email__c = sendEmail;
                errorlog.Email_Subject__c = emailSubject;
                errorlog.Email_Body__c = emailBody;
                insert errorlog;
                System.debug('***Error Log Record Id :'+ errorlog.id);
            }catch(Exception e){
                System.debug('****Failed to INSERT the [Apex Debug Log] Custom Logging record. ' +
                'Error: ' + e.getMessage());
                System.debug('****For the Class: ' + className + ' method: ' + methodName + 
                ' and the error is: ' + errorMessage);
            }
        }else{
            
            System.debug('Custom Error Logging option is disabled in Custom settings');
        }
        
    }    



/*   sample code to create logs

ErrorLogsUtils.createErrorLogs(String status, String className, String methodName, String errorMessage, String errorDescription, String recordID, String reqBody, String resBody, Boolean doNotDelete, ErrorLogsUtils.ERROR, Boolean sendEmail, String emailSubject, String emailBody);
        
Ex:
String description = 'Error: '+e.getMessage() + '; Stack Trace: '+e.getStackTraceString();
        ErrorLogsUtils.createErrorLogs('Failure', String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')), 'generateNewOAuthToken', e.getTypeName(), description, '', req.toString(), '', false, ErrorLogsUtils.ERROR, true, 'Subject', 'EmailBody');
    
Object Detials
    label: Error Logs
    name: Error_Logs__c
    keyPrefix: a85
    
*/


}