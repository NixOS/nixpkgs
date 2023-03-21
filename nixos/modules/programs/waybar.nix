{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.programs.waybar;
in
{
  options.programs.waybar = {
    enable = mkEnableOption (lib.mdDoc "waybar");
    package = mkPackageOptionMD pkgs "waybar" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.user.services.waybar = {
      description = "Waybar as systemd service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${cfg.package}/bin/waybar";
    };
  };

  meta.maintainers = [ maintainers.FlorianFranzen ];
}
