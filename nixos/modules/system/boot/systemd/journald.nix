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
      [ "services" "journald" "enableHttpGateway" ]
      [ "services" "journald" "gateway" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "rateLimitInterval" ]
      [ "services" "journald" "settings" "Journal" "RateLimitInterval" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "storage" ]
      [ "services" "journald" "settings" "Journal" "Storage" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "console" ]
      [ "services" "journald" "settings" "Journal" "TTYPath" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "rateLimitBurst" ]
      [ "services" "journald" "settings" "Journal" "RateLimitBurst" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "forwardToSyslog" ]
      [ "services" "journald" "settings" "Journal" "ForwardToSyslog" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "journald" "audit" ]
      [ "services" "journald" "settings" "Journal" "Audit" ]
    )
  ];

  options = {
    services.journald.settings.Journal = lib.mkOption {
      default = { };
      type = lib.types.submodule (
        { config, ... }:
        {
          freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
          options.Audit = lib.mkOption {
            default = "keep";
            type = lib.types.oneOf [
              lib.types.bool
              (lib.types.enum [ "keep" ])
            ];
            description = ''
              If enabled systemd-journald will turn on auditing on start-up.
              If disabled it will turn it off. If set to `keep` it will neither enable nor disable it, leaving the previous state unchanged.

              NixOS defaults to `keep`, as enabling audit without auditd running leads to spamming /dev/kmesg with random messages
              and if you enable auditd then auditd is responsible for turning auditing on.

              If you want to have audit logs in journald and do not mind audit logs also ending up in /dev/kmesg you can set this option to true.

              If you want to for some ununderstandable reason disable auditing if auditd enabled it, then you can set this option to false.
              It is of NixOS' opinion that setting this to false is definitely the wrong thing to do - but it's an option.
            '';
          };
          options.ForwardToConsole = lib.mkOption {
            default = config.TTYPath or "" != "";
            defaultText = lib.literalExpression ''services.journald.settings.Journal.TTYPath or "" != ""'';
            type = lib.types.bool;
            description = ''
              Whether to forward log messages to console.
            '';
          };
        }
      );
      description = ''
        Options for the the systemd journal service. See {manpage}`journald.conf(5)` man page
        for available options.
      '';
    };

    services.journald.extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = "Storage=volatile";
      description = ''
        Extra config options for systemd-journald. See {manpage}`journald.conf(5)`
        for available options.
      '';
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
      "syslog.socket"
    ];

    systemd.sockets.systemd-journald-audit.wantedBy = [
      "systemd-journald.service"
      "sockets.target"
    ];

    environment.etc."systemd/journald.conf".text =
      (utils.systemdUtils.lib.settingsToSections cfg.settings) + "\n${cfg.extraConfig}";

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
