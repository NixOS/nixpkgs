{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.driftwm;
in
{
  options.programs.driftwm = {
    enable = lib.mkEnableOption "driftwm, a trackpad-first infinite canvas Wayland compositor";

    package = lib.mkPackageOption pkgs "driftwm" { };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment = {
          systemPackages = [
            cfg.package
          ]
          # driftwm runs X11 clients through xwayland-satellite when it is in PATH
          ++ lib.optional config.programs.xwayland.enable pkgs.xwayland-satellite;

          # Bundled wallpaper shaders referenced by path in config.toml
          pathsToLink = [ "/share/driftwm" ];

          # Upstream documents copying the reference config from /etc
          etc."driftwm/config.reference.toml".source = "${cfg.package}/etc/driftwm/config.reference.toml";
        };

        services = {
          displayManager.sessionPackages = [ cfg.package ];

          # Secret portal backend chosen in driftwm-portals.conf
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };

        systemd.packages = [ cfg.package ];

        systemd.user.services.driftwm = {
          # Restarting the compositor would end the graphical session
          restartIfChanged = false;
          # Keep the PATH that driftwm-session imports into the user manager
          enableDefaultPath = false;
        };

        xdg.portal = {
          enable = lib.mkDefault true;
          configPackages = lib.mkDefault [ cfg.package ];
        };
      }

      (import ./wayland-session.nix { inherit lib pkgs; })
    ]
  );

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
