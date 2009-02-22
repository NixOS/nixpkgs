{
  boot = {
    grubDevice = "/dev/sda";
  };
  
  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda1";
    }
  ];

  services = {
  
    sshd = {
      enable = true;
    };

    httpd = {
      enable = true;
      experimental = true;
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
