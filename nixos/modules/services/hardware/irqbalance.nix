#
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.irqbalance;

in
{
  options.services.irqbalance.enable = mkEnableOption "irqbalance daemon";

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.irqbalance ];

    systemd.services.irqbalance.wantedBy = ["multi-user.target"];

    systemd.packages = [ pkgs.irqbalance ];

  };

}
