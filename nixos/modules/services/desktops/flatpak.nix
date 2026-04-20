# flatpak service.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.flatpak;
in

{
  meta = {
    doc = ./flatpak.md;
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  ###### interface
  options = {
    services.flatpak = {
      enable = lib.mkEnableOption "flatpak";

      package = lib.mkPackageOption pkgs "flatpak" { };

      autoUpdate = {
        enable = lib.mkEnableOption "autoUpdate" // {
          description = ''
            Whether to periodically update Flatpak apps to the latest
            version. If enabled, a systemd timer will run
            `flatpak update --asumeyes --noninteractive` once a day.

            This is usually handled by desktop environments, but it can
            be useful to enable on a minimal desktop environment.
          '';
        };

        dates = lib.mkOption {
          type = lib.types.str;
          default = "03:40";
          example = "daily";
          description = ''
            How often or when update occurs. For most desktop and server systems
            a sufficient update frequency is once a day.

            The format is described in
            {manpage}`systemd.time(7)`.
          '';
        };

        randomizedDelaySec = lib.mkOption {
          default = "0";
          type = lib.types.str;
          example = "45min";
          description = ''
            Add a randomized delay before each automatic update.
            The delay will be chosen between zero and this value.
            This value must be a time span in the format specified by
            {manpage}`systemd.time(7)`
          '';
        };

        fixedRandomDelay = lib.mkOption {
          default = false;
          type = lib.types.bool;
          example = true;
          description = ''
            Make the randomized delay consistent between runs.
            This reduces the jitter between automatic updates.
            See {option}`randomizedDelaySec` for configuring the randomized delay.
          '';
        };

        persistent = lib.mkOption {
          default = true;
          type = lib.types.bool;
          example = false;
          description = ''
            Takes a boolean argument. If true, the time when the service
            unit was last triggered is stored on disk. When the timer is
            activated, the service unit is triggered immediately if it
            would have been triggered at least once during the time when
            the timer was inactive. Such triggering is nonetheless
            subject to the delay imposed by RandomizedDelaySec=. This is
            useful to catch up on missed runs of the service when the
            system was powered down.
          '';
        };
      };

    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = (config.xdg.portal.enable == true);
        message = "To use Flatpak you must enable XDG Desktop Portals with xdg.portal.enable.";
      }
    ];

    environment.systemPackages = [
      cfg.package
      pkgs.fuse3
    ];

    security.polkit.enable = true;

    fonts.fontDir.enable = true;

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.packages = [ cfg.package ];

    systemd.services.flatpak-update = {
      startAt = lib.optional cfg.autoUpdate.enable cfg.autoUpdate.dates;
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "Flatpak apps auto update";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe' cfg.package "flatpak"} update --assumeyes --noninteractive";
      };
    };

    systemd.timers.flatpak-update = lib.mkIf cfg.autoUpdate.enable {
      description = "Timer for Flatpak auto update";
      timerConfig = {
        OnCalendar = cfg.autoUpdate.dates;
        RandomizedDelaySec = cfg.autoUpdate.randomizedDelaySec;
        Persistent = cfg.autoUpdate.persistent;
      };
    };

    environment.profiles = [
      "$HOME/.local/share/flatpak/exports"
      "/var/lib/flatpak/exports"
    ];

    # It has been possible since https://github.com/flatpak/flatpak/releases/tag/1.3.2
    # to build a SELinux policy module.

    # TODO: use sysusers.d
    users.users.flatpak = {
      description = "Flatpak system helper";
      group = "flatpak";
      isSystemUser = true;
    };

    users.groups.flatpak = { };
  };
}
