{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.niri;
in
{
  options.programs.niri = {
    enable = lib.mkEnableOption "Niri, a scrollable-tiling Wayland compositor";

    package = lib.mkPackageOption pkgs "niri" { };

    useNautilus = lib.mkEnableOption "Nautilus as file-chooser for xdg-desktop-portal-gnome" // {
      default = true;
    };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        alacritty
        fuzzel
        swaylock
        brightnessctl

        xwayland-satellite
      ];
      defaultText = lib.literalExpression ''
        with pkgs; [ brightnessctl alacritty fuzzel swaylock ];
      '';
      example = lib.literalExpression ''
        with pkgs; [ brightnessctl alacritty fuzzel swaylock ];
      '';
      description = ''
        Extra packages to be installed system wide.
        By default, they're the packages used in the base configuration, plus xwayland-satellite for running X11 apps.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = lib.optional (cfg.package != null) cfg.package ++ cfg.extraPackages;

        # Required for xdg-desktop-portal-gnome's FileChooser to work properly
        services.dbus.packages = lib.mkIf cfg.useNautilus [
          pkgs.nautilus
        ];

        services = {
          displayManager.sessionPackages = [ cfg.package ];

          # Recommended by upstream
          # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };

        systemd.packages = [ cfg.package ];

        xdg.portal = {
          enable = lib.mkDefault true;

          # NOTE: `configPackages` is ignored when `xdg.portal.config.niri` is defined.
          config.niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Access" = "gtk";
            "org.freedesktop.impl.portal.FileChooser" = lib.mkIf (!cfg.useNautilus) "gtk";
            "org.freedesktop.impl.portal.Notification" = "gtk";
            "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
          };

          # Recommended by upstream, required for screencast support
          # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };
      }

      (import ./wayland-session.nix {
        inherit lib pkgs;
        enableWlrPortal = false;
        enableXWayland = false;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    getchoo
    sodiboo
  ];
}
