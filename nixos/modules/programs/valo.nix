{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.valo;

in
{
  options = {
    programs.valo = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install Valo backlight control command.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.valo ];
    security.wrappers.valo.source = "${pkgs.valo.out}/bin/valo";
  };
}
