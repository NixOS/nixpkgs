#
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.irqbalance;

in
{
  options.services.irqbalance.enable = mkOption {
    type = types.bool;
    default = false;
    example = true;
    description = "Whether to enable irqbalance daemon.";
  };

  config = mkIf cfg.enable {

    systemd.services = {
      irqbalance = {
        description = "irqbalance daemon";
        path = [ pkgs.irqbalance ];
        serviceConfig =
          { ExecStart = "${pkgs.irqbalance}/bin/irqbalance --foreground"; };
        wantedBy = [ "multi-user.target" ];
      };
    };

    environment.systemPackages = [ pkgs.irqbalance ];

  };

}
