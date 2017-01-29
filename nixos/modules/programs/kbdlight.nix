{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kbdlight;

in
{
  options.programs.kbdlight.enable = mkEnableOption "kbdlight";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kbdlight ];
    security.wrappers.kbdlight.source = "${pkgs.kbdlight.out}/bin/kbdlight";
  };
}
