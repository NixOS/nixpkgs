{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.coolercontrol;
  pluginUser = "cc-plugin-user";
in
{
  ##### interface
  options = {
    programs.coolercontrol = {
      enable = lib.mkEnableOption "CoolerControl GUI & its background services";

      plugins.enable = lib.mkEnableOption ''
        support for CoolerControl service plugins.

        Declares the `${pluginUser}` system user and group that unprivileged plugins run
        as.
      '';
    };
  };

  imports = [
    # Added 2025-10-25
    (lib.mkRemovedOptionModule [ "programs" "coolercontrol" "nvidiaSupport" ] ''
      This option is deprecated as Nvidia drivers are automatically loaded at runtime.
    '')
  ];

  ##### implementation
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Common
      {
        environment.systemPackages = with pkgs.coolercontrol; [
          coolercontrol-gui
        ];

        systemd = {
          packages = with pkgs.coolercontrol; [
            coolercontrold
          ];

          # https://github.com/NixOS/nixpkgs/issues/81138
          services = {
            coolercontrold = {
              wantedBy = [ "multi-user.target" ];

              # The daemon writes a unit file per service plugin, then reloads and starts
              # it. Its default target, /etc/systemd/system, is a symlink into the store
              # here, so the write fails. /run/systemd/system is writable and systemd
              # searches it ahead of /etc. Units there do not survive a reboot, which is
              # fine: the daemon rewrites them for every plugin on each start.
              environment.CC_SERVICE_DIR = "/run/systemd/system";
            };
          };
        };
      }

      # Service plugins
      (lib.mkIf cfg.plugins.enable {
        users.users.${pluginUser} = {
          isSystemUser = true;
          group = pluginUser;
          description = "CoolerControl unprivileged plugin user";
        };

        # A plugin unit sets both User= and Group= to this name, and the daemon chowns
        # plugin directories to `${pluginUser}:${pluginUser}`.
        users.groups.${pluginUser} = { };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    OPNA2608
    codifryed
  ];
}
