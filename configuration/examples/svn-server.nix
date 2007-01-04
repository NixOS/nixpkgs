{
  boot = {
    autoDetectRootDevice = false;
    rootDevice = "/dev/hda1";
    readOnlyRoot = false;
    grubDevice = "/dev/hda";
  };
  
  services = {
  
    sshd = {
      enable = true;
    };

    httpd = {
      enable = true;
      adminAddr = "admin@example.org";

      subservices = {

        subversion = {
          enable = true;
          dataDir = "/data/subversion";
          notificationSender = "svn@example.org";
        };

      };
      
    };
    
  };
  
}
