# Support for DRBD, the Distributed Replicated Block Device.

{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.drbd; in

{

  ###### interface

  options = {

    services.drbd.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable support for DRBD, the Distributed Replicated
        Block Device.
      '';
    };

    services.drbd.config = mkOption {
      default = "";
      type = types.string;
      description = ''
        Contents of the <filename>drbd.conf</filename> configuration file.
      '';
    };

  };

  
  ###### implementation

  config = mkIf cfg.enable {
  
    environment.systemPackages = [ pkgs.drbd ];
    
    services.udev.packages = [ pkgs.drbd ];

    boot.kernelModules = [ "drbd" ];

    boot.extraModprobeConfig =
      ''
        options drbd usermode_helper=/run/current-system/sw/sbin/drbdadm
      '';

    environment.etc = singleton
      { source = pkgs.writeText "drbd.conf" cfg.config;
        target = "drbd.conf";
      };

    jobs.drbd_up =
      { name = "drbd-up";
        startOn = "stopped udevtrigger or ip-up";
        task = true;
        script =
          ''
            ${pkgs.drbd}/sbin/drbdadm up all
          '';
      };
    
    jobs.drbd_down =
      { name = "drbd-down";
        startOn = "starting shutdown";
        task = true;
        script =
          ''
            ${pkgs.drbd}/sbin/drbdadm down all
          '';
      };
    
  };
  
}
