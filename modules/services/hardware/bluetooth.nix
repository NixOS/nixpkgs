{pkgs, config, ...}:

with pkgs.lib;

{

  ###### interface

  options = {
  
  };


  ###### implementation
  
  config = {

    environment.systemPackages = [pkgs.bluez pkgs.openobex pkgs.obexftp];

    services.udev.packages = [pkgs.bluez];
    
  };  
  
}
