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
      type = types.lines;
      description = ''
        Contents of the <filename>drbd.conf</filename> configuration file.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.drbd-utils ];

    services.udev.packages = [ pkgs.drbd-utils ];

    boot.kernelModules = [ "drbd" ];

    boot.extraModprobeConfig =
      ''
        options drbd usermode_helper=/run/current-system/sw/bin/drbdadm
      '';

    environment.etc.drbd.conf =
      { source = pkgs.writeText "drbd.conf" cfg.config; };

    systemd.services.drbd = {
      description = "Distributed Replicated Block Device";
      after = [ "systemd-udev.settle.service" "network.target" ];
      wants = [ "systemd-udev.settle.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      preStart = ''
        # Check the configuration file for syntax errors
        ${pkgs.drbd}/bin/drbdadm sh-nop
      '';
      script = ''
        # Activate all resources on start
        ${pkgs.drbd-utils}/bin/drbdadm up all
      '';
      reload = ''
        # Re-adjust everything on reload
        ${pkgs.drbd-utils}/bin/drbdadm adjust all
      '';
      preStop = ''
        # Deactivate all resources on stop
        ${pkgs.drbd-utils}/bin/drbdadm down all
      '';
    };
  };
}
