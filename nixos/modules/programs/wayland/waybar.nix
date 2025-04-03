{
  lib,
  pkgs,
  config,
  ...
}:

let
  json = pkgs.formats.json { };
  cfg = config.programs.waybar;
in
{
  options.programs.waybar = {
    enable = lib.mkEnableOption "waybar, a highly customizable Wayland bar for Sway and Wlroots based compositors";
    package = lib.mkPackageOption pkgs "waybar" { } // {
      apply = pkg: pkg.override { systemdSupport = true; };
    };

    settings = lib.mkOption {
      type = json.type;
      default = { };
      description = "waybar configuration, see man waybar(5)";
      example = lib.literalExpression ''
        {
          layer = "top";
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = [ "battery" "clock" ];

          "sway/window" = {
            max-length = 50;
          };

          battery = {
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
          };

          clock = {
            format-alt = "{:%a, %d. %b  %H:%M}";
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."xdg/waybar/config".source = json.generate "waybar-config" cfg.settings;
    };

    systemd = {
      packages = [ cfg.package ];
      user.services.waybar.wantedBy = [ "graphical-session.target" ];
    };
  };

  meta.maintainers = [ lib.maintainers.FlorianFranzen ];
}
