{
  config,
  lib,
  utils,
  ...
}:

let
  cfg = config.services.timesyncd;
in
{

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "timesyncd"
      "extraConfig"
    ] "Use services.timesyncd.settings.Time instead.")
  ];

  options = {

    services.timesyncd = {
      enable = lib.mkOption {
        default = !config.boot.isContainer;
        defaultText = lib.literalExpression "!config.boot.isContainer";
        type = lib.types.bool;
        description = ''
          Enables the systemd NTP client daemon.
        '';
      };
      servers = lib.mkOption {
        default = null;
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        description = ''
          The set of NTP servers from which to synchronise.

          Setting this option to an empty list will write `NTP=` to the
          {file}`timesyncd.conf` file as opposed to setting this option to null which
          will remove `NTP=` entirely.

          See {manpage}`timesyncd.conf(5)` for details.
        '';
      };
      fallbackServers = lib.mkOption {
        default = config.networking.timeServers;
        defaultText = lib.literalExpression "config.networking.timeServers";
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        description = ''
          The set of fallback NTP servers from which to synchronise.

          Setting this option to an empty list will write `FallbackNTP=` to the
          {file}`timesyncd.conf` file as opposed to setting this option to null which
          will remove `FallbackNTP=` entirely.

          See {manpage}`timesyncd.conf(5)` for details.
        '';
      };
      settings.Time = lib.mkOption {
        default = { };
        type = lib.types.submodule {
          freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
        };
        example = {
          PollIntervalMaxSec = 180;
        };
        description = ''
          Settings for systemd-timesyncd. See {manpage}`timesyncd.conf(5)` for
          available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.additionalUpstreamSystemUnits = [ "systemd-timesyncd.service" ];

    systemd.services.systemd-timesyncd = {
      wantedBy = [ "sysinit.target" ];
      aliases = [ "dbus-org.freedesktop.timesync1.service" ];
      restartTriggers = [ config.environment.etc."systemd/timesyncd.conf".source ];
      # systemd-timesyncd disables DNSSEC validation in the nss-resolve module by setting SYSTEMD_NSS_RESOLVE_VALIDATE to 0 in the unit file.
      # This is required in order to solve the chicken-and-egg problem when DNSSEC validation needs the correct time to work, but to set the
      # correct time, we need to connect to an NTP server, which usually requires resolving its hostname.
      # In order for nss-resolve to be able to read this environment variable we patch systemd-timesyncd to disable NSCD and use NSS modules directly.
      # This means that systemd-timesyncd needs to have NSS modules path in LD_LIBRARY_PATH. When systemd-resolved is disabled we still need to set
      # NSS module path so that systemd-timesyncd keeps using other NSS modules that are configured in the system.
      environment.LD_LIBRARY_PATH = config.system.nssModules.path;
    };

    services.timesyncd.settings.Time = lib.mkMerge [
      (lib.mkIf (cfg.servers != null) {
        NTP = lib.mkDefault (lib.concatStringsSep " " cfg.servers);
      })
      (lib.mkIf (cfg.fallbackServers != null) {
        FallbackNTP = lib.mkDefault (lib.concatStringsSep " " cfg.fallbackServers);
      })
    ];

    environment.etc."systemd/timesyncd.conf".text =
      utils.systemdUtils.lib.settingsToSections cfg.settings;

    users.users.systemd-timesync = {
      uid = config.ids.uids.systemd-timesync;
      group = "systemd-timesync";
    };
    users.groups.systemd-timesync.gid = config.ids.gids.systemd-timesync;
  };
}
