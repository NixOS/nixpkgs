# Udisks daemon.

{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.udisks2 = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Udisks, a DBus service that allows
          applications to query and manipulate storage devices.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.udisks2.enable {

    environment.systemPackages = [ pkgs.udisks2 ];

    services.dbus.packages = [ pkgs.udisks2 ];

    system.activationScripts.udisks2 =
      ''
        mkdir -m 0755 -p /var/lib/udisks2
      '';

    #services.udev.packages = [ pkgs.udisks2 ];
    
    systemd.services.udisks2 = {
      description = "Udisks2 service";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.UDisks2";
        ExecStart = "${pkgs.udisks2}/lib/udisks2/udisksd --no-debug";
      };
    };
  };

}
