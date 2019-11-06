{ lib, pkgs, config, ... }:

with lib;

{
  options.programs.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf config.programs.waybar.enable {
    systemd.user.services.waybar = {
      description = "Waybar as systemd service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "always";
      };
    };
  };

  meta.maintainers = [ maintainers.FlorianFranzen ];
}
