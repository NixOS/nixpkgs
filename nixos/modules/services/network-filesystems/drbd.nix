{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.drbd; in

{

  options = {

    services.drbd.enable = mkEnableOption "support for DRBD, the Distributed Replicated Block Device";

    services.drbd.config = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Contents of the <filename>drbd.conf</filename> configuration file.
      '';
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.drbd-utils ];

    services.udev.packages = [ pkgs.drbd-utils ];

    boot.kernelModules = [ "drbd" ];

    boot.extraModprobeConfig = ''
      options drbd usermode_helper=/run/current-system/sw/bin/drbdadm
    '';

    environment.etc."drbd.conf" = {
      source = pkgs.writeText "drbd.conf" cfg.config;
    };

    systemd.services.drbd = {
      description = "Distributed Replicated Block Device";
      after = [ "systemd-udev.settle.service" "network.target" ];
      wants = [ "systemd-udev.settle.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      path = [ pkgs.drbd-utils ];
      restartTriggers = [ config.environment.etc."drbd.conf".source ];
      preStart = ''
        # Check the configuration file for syntax errors
        ${pkgs.drbd-utils}/bin/drbdadm sh-nop
      '';
      script = ''
        # Activate all resources on start
        ${pkgs.drbd-utils}/bin/drbdadm adjust all
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
