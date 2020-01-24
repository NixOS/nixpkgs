#
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.irqbalance;

in
{
  options.services.irqbalance.enable = mkEnableOption "irqbalance daemon";

  config = mkIf cfg.enable {

    systemd.services = {
      irqbalance = {
        description = "irqbalance daemon";
        path = [ pkgs.irqbalance ];
        serviceConfig = {
          ExecStart = "${pkgs.irqbalance}/bin/irqbalance --foreground";
          CapabilityBoundingSet = "";
          NoNewPrivileges = "yes";
          ReadOnlyPaths = "/";
          ReadWritePaths = "/proc/irq";
          RestrictAddressFamilies = "AF_UNIX";
          RuntimeDirectory = "irqbalance/";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

    environment.systemPackages = [ pkgs.irqbalance ];

  };

}
