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
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [
          cfg.package
        ];

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

        # Restarting the compositor kills the graphical session; same
        # treatment as the display-manager modules.
        systemd.user.services.niri = {
          restartIfChanged = false;
          # Defining the unit here generates a drop-in; without this it
          # would carry the NixOS default Environment="PATH=coreutils:…",
          # clobbering the PATH that niri-session imported into the user
          # manager and breaking spawn actions that rely on it.
          enableDefaultPath = false;
        };

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
