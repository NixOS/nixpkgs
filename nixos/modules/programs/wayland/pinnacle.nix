{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.pinnacle;
  inherit (lib.options) mkEnableOption mkPackageOption;
in
{
  options.programs.pinnacle = {
    enable = mkEnableOption "pinnacle";
    package = mkPackageOption pkgs "pinnacle" {
      default = "pinnacle";
      example = "pkgs.pinnacle";
      extraDescription = "package containing the pinnacle server binary";
    };
    xdg-portals.enable = mkEnableOption "enable xdg-portals for pinnacle";
    withUWSM = mkEnableOption ''
      manage the pinnacle session with [UWSM](https://github.com/Vladimir-csp/uwsm) instead
      of independent systemd services and targets.
    '';
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];
        xdg.portal = lib.mkIf cfg.xdg-portals.enable {
          enable = true;
          wlr.enable = true;
          configPackages = [ cfg.package ];
          extraPortals = [
            pkgs.xdg-desktop-portal-wlr
            pkgs.xdg-desktop-portal-gtk
            pkgs.gnome-keyring
          ];
        };
      }
      (lib.mkIf (cfg.withUWSM) {
        programs.uwsm.enable = true;
        # Configure UWSM to launch Pinnacle from a display manager like SDDM
        programs.uwsm.waylandCompositors = {
          pinnacle = {
            prettyName = "Pinnacle";
            comment = "Pinnacle compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/pinnacle";
            extraArgs = [ "--session" ];
          };
        };
      })
      (lib.mkIf (!cfg.withUWSM) {
        services.displayManager.sessionPackages = [ cfg.package ];
      })
    ]
  );
}
