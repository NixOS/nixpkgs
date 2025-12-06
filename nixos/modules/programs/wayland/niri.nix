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

        xdg.portal = {
          enable = lib.mkDefault true;

          configPackages = [ cfg.package ];

          config.niri = lib.mkIf (!cfg.useNautilus) {
            "org.freedesktop.impl.portal.FileChooser" = lib.mkDefault "gtk";
          };

          # Recommended by upstream, required for screencast support
          # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };

        # Recommended for Nvidia GPU's
        # https://github.com/YaLTeR/niri/wiki/Nvidia#high-vram-usage-fix
        environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
          ''
            {
              "rules": [
                  {
                      "pattern": {
                          "feature": "procname",
                          "matches": "niri"
                      },
                      "profile": "Limit Free Buffer Pool On Wayland Compositors"
                  }
              ],
              "profiles": [
                  {
                      "name": "Limit Free Buffer Pool On Wayland Compositors",
                      "settings": [
                          {
                              "key": "GLVidHeapReuseRatio",
                              "value": 0
                          }
                      ]
                  }
              ]
            }'';
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
