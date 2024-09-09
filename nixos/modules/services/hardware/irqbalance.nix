#
{ config, lib, pkgs, ... }:
let

  cfg = config.services.irqbalance;

in
{
  options.services.irqbalance.enable = lib.mkEnableOption "irqbalance daemon";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.irqbalance ];

    systemd.services.irqbalance.wantedBy = ["multi-user.target"];

    systemd.packages = [ pkgs.irqbalance ];

  };

}
