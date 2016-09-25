{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kbdlight;

in
{
  options.programs.kbdlight.enable = mkOption {
    default = false;
    example = true;
    type = types.bool;
    description = "Whether to enable kbdlight.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kbdlight ];
    security.setuidPrograms = [ "kbdlight" ];
  };
}
