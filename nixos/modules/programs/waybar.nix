{ lib, pkgs, config, ... }:

with lib;

{
  options.programs.waybar = {
    enable = mkEnableOption (lib.mdDoc "waybar");
  };

  config = mkIf config.programs.waybar.enable {
    systemd.user.services.waybar = {
      description = "Waybar as systemd service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.waybar}/bin/waybar";
    };
  };

  meta.maintainers = [ maintainers.FlorianFranzen ];
}
