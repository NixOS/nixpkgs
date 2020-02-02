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

    systemd.packages = [ pkgs.irqbalance ];

  };

}
