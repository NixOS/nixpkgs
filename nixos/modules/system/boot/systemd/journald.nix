{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.journald;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "journald" "enableHttpGateway" ]
      [ "services" "journald" "gateway" "enable" ]
    )

    (lib.mkRemovedOptionModule [
      "services"
      "journald"
      "extraConfig"
    ] "Use services.journald.settings.Journal instead.")
    (lib.mkRenamedOptionModule
      [ "services" "journald" "console" ]
      [ "services" "journald" "settings" "Journal" "TTYPath" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "rateLimitInterval" ]
      [ "services" "journald" "settings" "Journal" "RateLimitIntervalSec" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "rateLimitBurst" ]
      [ "services" "journald" "settings" "Journal" "RateLimitBurst" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "storage" ]
      [ "services" "journald" "settings" "Journal" "Storage" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "audit" ]
      [ "services" "journald" "settings" "Journal" "Audit" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "forwardToSyslog" ]
      [ "services" "journald" "settings" "Journal" "ForwardToSyslog" ]
    )
  ];

  options = {
    services.journald.settings.Journal = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
      };
      example = {
        Storage = "volatile";
        ForwardToSyslog = true;
      };
      description = ''
        Settings for systemd-journald. See {manpage}`journald.conf(5)`
        for available options.
      '';
    };
  };

  config = {
    services.journald.settings.Journal = {
      Storage = lib.mkDefault "persistent";
      RateLimitIntervalSec = lib.mkDefault "30s";
      RateLimitBurst = lib.mkDefault 10000;
      Audit = lib.mkDefault "keep";
      ForwardToSyslog = lib.mkDefault (
        config.services.rsyslogd.enable || config.services.syslog-ng.enable
      );
    };

    systemd.additionalUpstreamSystemUnits = [
      "systemd-journald.socket"
      "systemd-journald@.socket"
      "systemd-journald-varlink@.socket"
      "systemd-journald.service"
      "systemd-journald@.service"
      "systemd-journal-flush.service"
      "systemd-journal-catalog-update.service"
      "systemd-journald-sync@.service"
      "systemd-journald-audit.socket"
      "systemd-journald-dev-log.socket"
      "syslog.socket"
    ];

    systemd.sockets.systemd-journald-audit.wantedBy = [
      "systemd-journald.service"
      "sockets.target"
    ];

    environment.etc = {
      "systemd/journald.conf".text = utils.systemdUtils.lib.settingsToSections cfg.settings;
    };

    users.groups.systemd-journal.gid = config.ids.gids.systemd-journal;

    systemd.services.systemd-journal-flush.restartIfChanged = false;
    systemd.services.systemd-journald.restartTriggers = [
      config.environment.etc."systemd/journald.conf".source
    ];
    systemd.services.systemd-journald.stopIfChanged = false;
    systemd.services."systemd-journald@".restartTriggers = [
      config.environment.etc."systemd/journald.conf".source
    ];
    systemd.services."systemd-journald@".stopIfChanged = false;
  };
}
