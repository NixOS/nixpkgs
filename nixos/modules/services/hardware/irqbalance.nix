#
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.irqbalance;

in
{
  options.services.irqbalance.enable = mkEnableOption' {
    name = "irqbalance daemon";
    package = literalPackage pkgs "pkgs.irqbalance";
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
