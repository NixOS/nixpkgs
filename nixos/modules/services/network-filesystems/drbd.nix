# Support for DRBD, the Distributed Replicated Block Device.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.drbd;
in

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
        Contents of the {file}`drbd.conf` configuration file.
      '';
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.drbd ];

    services.udev.packages = [ pkgs.drbd ];

    boot.kernelModules = [ "drbd" ];

    boot.extraModprobeConfig = ''
      options drbd usermode_helper=/run/current-system/sw/bin/drbdadm
    '';

    environment.etc."drbd.conf" = {
      source = pkgs.writeText "drbd.conf" cfg.config;
    };

    systemd.services.drbd = {
      after = [
        "systemd-udev.settle.service"
        "network.target"
      ];
      wants = [ "systemd-udev.settle.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.drbd}/bin/drbdadm up all";
        ExecStop = "${pkgs.drbd}/bin/drbdadm down all";
      };
    };
  };
}
