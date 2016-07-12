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

    boot.stage2Init = "${pkgs.systemd-bootchart}/lib/systemd/systemd-bootchart";

    environment.etc."systemd/bootchart.conf".text = ''
      [Bootchart]
      ${cfg.extraConfig}
    '';

    system.requiredKernelConfig = map config.lib.kernelConfig.isYes [ "SCHEDSTATS" "SCHED_DEBUG" ];

  };

}
