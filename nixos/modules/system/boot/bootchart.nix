{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.bootchart;

in

{

  options = {

    boot.bootchart.enable = mkEnableOption "systemd-bootchart, boot performance analysis tool";

    boot.bootchart.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "Samples=500";
      description = ''
        Extra config options for systemd-bootchart. See man bootchart.conf
        for available options.
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.packages = [ pkgs.systemd-bootchart ];

    boot.kernelParams = [ "init2=${pkgs.systemd-bootchart}/lib/systemd/systemd-bootchart" ];

    systemd.services.systemd-bootchart.wantedBy = [ "sysinit.target" ];

    environment.etc."systemd/bootchart.conf".text = ''
      [Bootchart]
      ${cfg.extraConfig}
    '';

    system.requiredKernelConfig = [ config.lib.kernelConfig.isYes "SCHEDSTATS" ];

  };

}
