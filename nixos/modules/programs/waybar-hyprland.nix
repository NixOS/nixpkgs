{ lib, pkgs, config, ... }:

with lib;

{
  options.programs.waybar-hyprland = {
    enable = mkEnableOption (lib.mdDoc "waybar");
  };

  config = mkIf config.programs.waybar-hyprland.enable {
    systemd.user.services.waybar = {
      description = "Waybar as systemd service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${pkgs.waybar-hyprland}/bin/waybar";
    };
  };

  meta.maintainers = [ maintainers.icedborn ];
}
