{
  config,
  pkgs,
  lib,
  ...
}:
let
  toml = pkgs.formats.toml { };
  cfg = config.services.dunst;
in
{
  options.services.dunst = {
    enable = lib.mkEnableOption "Dunst notification daemon";

    package = lib.mkPackageOption pkgs "dunst" { } // {
      apply =
        p:
        p.override {
          withX11 = cfg.enableX11;
          withWayland = cfg.enableWayland;
        };
    };

    settings = lib.mkOption {
      type = toml.type;
      default = { };
      description = "Dunst configuration, see dunst(5)";
      example = lib.literalExpression ''
        {
          global = {
            width = 300;
            height = 300;
            offset = "30x50";
            origin = "top-right";
            transparency = 10;
            frame_color = "#eceff1";
            font = "Droid Sans 9";
          };

          urgency_normal = {
            background = "#37474f";
            foreground = "#eceff1";
            timeout = 10;
          };
        };
      '';
    };

    enableX11 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable X11 support.";
    };

    enableWayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Wayland support.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enableX11 || cfg.enableWayland;
        message = "Dunst must be built with at least either X11 support or Wayland support";
      }
    ];

    environment = {
      systemPackages = [ cfg.package ];
      etc."xdg/dunst/dunstrc".source = toml.generate "dunstrc" cfg.settings;
    };

    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ nyukuru ];
}
