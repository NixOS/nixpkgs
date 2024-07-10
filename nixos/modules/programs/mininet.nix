# Global configuration for mininet
# kernel must have NETNS/VETH/SCHED
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.mininet;
in
{
  options.programs.mininet.enable = lib.mkEnableOption "Mininet, an emulator for rapid prototyping of Software Defined Networks";

  config = lib.mkIf cfg.enable {

    virtualisation.vswitch.enable = true;

    environment.systemPackages = [ pkgs.mininet ];
  };
}
