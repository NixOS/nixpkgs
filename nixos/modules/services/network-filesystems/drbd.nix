# Support for DRBD, the Distributed Replicated Block Device.

{ config, lib, pkgs, ... }:

with lib;

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
        options drbd usermode_helper=/run/current-system/sw/bin/drbdadm
      '';

    environment.etc = singleton
      { source = pkgs.writeText "drbd.conf" cfg.config;
        target = "drbd.conf";
      };

    systemd.services.drbd = {
      after = [ "systemd-udev.settle.service" "network.target" ];
      wants = [ "systemd-udev.settle.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.drbd}/sbin/drbdadm up all
      '';
      serviceConfig.ExecStop = ''
        ${pkgs.drbd}/sbin/drbdadm down all
      '';
    };
  };
}
