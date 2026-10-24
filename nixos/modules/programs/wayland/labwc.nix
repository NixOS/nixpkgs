{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.labwc;
in
{
  meta.maintainers = [ ];

  options.programs.labwc = {
    enable = lib.mkEnableOption "labwc";
    package = lib.mkPackageOption pkgs "labwc" { };

    withUWSM = lib.mkEnableOption null // {
      default = false;
      example = true;
      description = ''
        Launch labwc with the UWSM (Universal Wayland Session Manager) session manager.
        This has improved systemd support and is recommended for most users.
        This automatically starts appropriate targets like `graphical-session.target`,
        and `wayland-wm@labwc.service`.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        xdg.portal.config.wlroots.default = lib.mkDefault [
          "wlr"
          "gtk"
        ];
      }

      (lib.mkIf (cfg.withUWSM) {
        programs.uwsm.enable = true;

        # Configure UWSM to launch labwc from a display manager
        programs.uwsm.waylandCompositors = {
          labwc = {
            prettyName = "labwc";
            comment = "Lab Wayland Compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/labwc";
          };
        };
      })

      (lib.mkIf (!cfg.withUWSM) {
        # Make a plain labwc session available for display managers
        services.displayManager.sessionPackages = [ cfg.package ];
      })

      (import ./wayland-session.nix { inherit lib pkgs; })
    ]
  );
}
