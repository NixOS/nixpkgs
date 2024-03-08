# Global configuration for mininet
# kernel must have NETNS/VETH/SCHED
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.mininet;
in
{
  options.programs.mininet.enable = mkEnableOption (lib.mdDoc "Mininet");

  config = mkIf cfg.enable {

    virtualisation.vswitch.enable = true;

    environment.systemPackages = [ pkgs.mininet ];
  };
}
