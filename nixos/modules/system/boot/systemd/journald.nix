{
  config,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.journald;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "journald" "storage" ]
      [ "services" "journald" "settings" "Journal" "Storage" ]
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
      [ "services" "journald" "forwardToSyslog" ]
      [ "services" "journald" "settings" "Journal" "ForwardToSyslog" ]
    )
    (lib.mkRemovedOptionModule
      [
        "services"
        "journald"
        "console"
      ]
      "Use services.journald.settings.Journal.ForwardToConsole and services.journald.settings.Journal.TTYPath instead."
    )
    (lib.mkRemovedOptionModule
      [
        "services"
        "journald"
        "audit"
      ]
      "Use services.journald.settings.Journal.Audit instead. The previous default of `keep` corresponds to leaving the setting unset."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "journald"
      "extraConfig"
    ] "Use services.journald.settings.Journal instead.")
  ];

  options = {
    services.journald.settings.Journal = lib.mkOption {
      default = { };
      example = {
        Storage = "volatile";
        ForwardToConsole = true;
        TTYPath = "/dev/tty12";
      };
      description = ''
        Options for the systemd journal service. See {manpage}`journald.conf(5)`
        man page for available options.
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;

        options.Storage = lib.mkOption {
          default = "persistent";
          type = lib.types.enum [
            "persistent"
            "volatile"
            "auto"
            "none"
          ];
          description = ''
            Controls where to store journal data. See
            {manpage}`journald.conf(5)` for further information.
          '';
        };

        options.RateLimitIntervalSec = lib.mkOption {
          default = "30s";
          type = lib.types.str;
          description = ''
            Rate limiting interval applied to all messages generated on the
            system. Set to `0` to disable rate limiting. See
            {manpage}`journald.conf(5)` for further information.
          '';
        };

        options.RateLimitBurst = lib.mkOption {
          default = 10000;
          type = lib.types.int;
          description = ''
            Rate limiting burst limit (number of messages per interval) applied
            to all messages generated on the system. See
            {manpage}`journald.conf(5)` for further information.
          '';
        };
      };
    };
  };

  config = {
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
      "systemd-journalctl.socket"
      "systemd-journalctl@.service"
      "syslog.socket"
    ];

    systemd.sockets.systemd-journald-audit.wantedBy = [
      "systemd-journald.service"
      "sockets.target"
    ];

    environment.etc."systemd/journald.conf".text =
      utils.systemdUtils.lib.settingsToSections cfg.settings;

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
