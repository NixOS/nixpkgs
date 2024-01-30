{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.programs.waybar;
in
{
  options.programs.waybar = {
    enable = mkEnableOption (lib.mdDoc "waybar");
    package = mkPackageOption pkgs "waybar" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.user.services.waybar.wantedBy = [ "graphical-session.target" ];
  };

  meta.maintainers = [ maintainers.FlorianFranzen ];
}
