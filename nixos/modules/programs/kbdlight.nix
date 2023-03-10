{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kbdlight;

in
{
  options.programs.kbdlight.enable = mkEnableOption (lib.mdDoc "kbdlight");

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kbdlight ];
    security.wrappers.kbdlight =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.kbdlight.out}/bin/kbdlight";
      };
  };
}
