{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kbdlight;

in
{
  options.programs.kbdlight.enable = mkEnableOption' {
    name = "kbdlight";
    package = literalPackage pkgs "pkgs.kbdlight";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kbdlight ];
    security.setuidPrograms = [ "kbdlight" ];
  };
}
