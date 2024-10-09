{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.waybar;
in
{
  options.programs.waybar = {
    enable = lib.mkEnableOption "waybar, a highly customizable Wayland bar for Sway and Wlroots based compositors";
    package =
      lib.mkPackageOption pkgs "waybar" { }
      // lib.mkOption {
        apply = pkg: pkg.override { systemdSupport = true; };
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd = {
      packages = [ cfg.package ];
      user.services.waybar.wantedBy = [ "graphical-session.target" ];

      # If Waybar modules/configurations are using executables/commands without their explicit PATHs
      # they might not work as we are using a systemd service to start Waybar
      # Here we are manually importing PATH variable to the service environment fixing the issue
      user.services.waybar.environment.PATH =
        lib.mkOverride 90
          "/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    };
  };

  meta.maintainers = [ lib.maintainers.FlorianFranzen ];
}
