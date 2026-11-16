{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dux-files;
in
{
  options.programs.dux-files = {
    enable = lib.mkEnableOption "Dux Files, a standalone file manager for Wayland";

    package = lib.mkPackageOption pkgs "dux-files" { };

    systemd = {
      enable = lib.mkEnableOption "starting Dux Files with the graphical session";

      target = lib.mkOption {
        type = lib.types.str;
        default = "graphical-session.target";
        example = "wayland-session.target";
        description = "The systemd user target that starts Dux Files.";
      };

      restartIfChanged = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to restart the Dux Files user service when its package or configuration changes.";
      };
    };

    portal.enable = lib.mkEnableOption "the Dux Files file-chooser portal backend" // {
      description = ''
        Whether to enable XDG desktop portals and register the Dux Files
        file-chooser backend.

        Select Dux Files for open and save dialogs with:

        ```nix
        xdg.portal.config.common."org.freedesktop.impl.portal.FileChooser" = [ "dfiles" ];
        ```

        Use the configuration for your desktop instead of `common` if your
        desktop provides its own portal configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    security.polkit.enable = lib.mkDefault true;

    systemd.packages = lib.mkIf cfg.systemd.enable [ cfg.package ];

    systemd.user.services.dfiles = lib.mkIf cfg.systemd.enable {
      wantedBy = [ cfg.systemd.target ];
      restartIfChanged = cfg.systemd.restartIfChanged;
    };

    xdg.portal = lib.mkIf cfg.portal.enable {
      enable = true;
      extraPortals = [ cfg.package ];
    };
  };

  meta.teams = [ lib.teams.duxlabs ];
}
