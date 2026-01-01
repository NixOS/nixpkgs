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
<<<<<<< HEAD
        ];

        # Required for xdg-desktop-portal-gnome's FileChooser to work properly
        services.dbus.packages = lib.mkIf cfg.useNautilus [
=======
        ]
        # Required for xdg-desktop-portal-gnome's FileChooser to work properly
        ++ lib.optionals cfg.useNautilus [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
          configPackages = [ cfg.package ];

          config.niri = lib.mkIf (!cfg.useNautilus) {
            "org.freedesktop.impl.portal.FileChooser" = lib.mkDefault "gtk";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
