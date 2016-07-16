{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kbdlight;

in
{
  options.programs.kbdlight.enable = mkEnableOption "kbdlight";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kbdlight ];

    security.permissionsWrappers.setuid =
    [ { program = "kbdlight";
        source  = "${pkgs.kbdlight.out}/bin/kbdlight";
        user    = "root";
        group   = "root";
        setuid  = true;        
    }];
  };
}
