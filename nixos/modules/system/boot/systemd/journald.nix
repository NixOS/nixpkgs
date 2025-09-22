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
  ];

  options = {
    services.journald.console = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "If non-empty, write log messages to the specified TTY device.";
    };

    services.journald.rateLimitInterval = lib.mkOption {
      default = "30s";
      type = lib.types.str;
      description = ''
        Configures the rate limiting interval that is applied to all
        messages generated on the system. This rate limiting is applied
        per-service, so that two services which log do not interfere with
        each other's limit. The value may be specified in the following
        units: s, min, h, ms, us. To turn off any kind of rate limiting,
        set either value to 0.

        See {option}`services.journald.rateLimitBurst` for important
        considerations when setting this value.
      '';
    };

    services.journald.storage = lib.mkOption {
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

    services.journald.rateLimitBurst = lib.mkOption {
      default = 10000;
      type = lib.types.int;
      description = ''
        Configures the rate limiting burst limit (number of messages per
        interval) that is applied to all messages generated on the system.
        This rate limiting is applied per-service, so that two services
        which log do not interfere with each other's limit.

        Note that the effective rate limit is multiplied by a factor derived
        from the available free disk space for the journal as described on
        {manpage}`journald.conf(5)`.

        Note that the total amount of logs stored is limited by journald settings
        such as `SystemMaxUse`, which defaults to 10% the file system size
        (capped at max 4GB), and `SystemKeepFree`, which defaults to 15% of the
        file system size.

        It is thus recommended to compute what period of time that you will be
        able to store logs for when an application logs at full burst rate.
        With default settings for log lines that are 100 Bytes long, this can
        amount to just a few hours.
      '';
    };

    services.journald.audit = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.bool;
      description = ''
        If enabled systemd-journald will turn on auditing on start-up.
        If disabled it will turn it off. If unset it will neither enable nor disable it, leaving the previous state unchanged.

        NixOS defaults to leaving this unset as enabling audit without auditd running leads to spamming /dev/kmesg with random messages
        and if you enable auditd then auditd is responsible for turning auditing on.

        If you want to have audit logs in journald and do not mind audit logs also ending up in /dev/kmesg you can set this option to true.

        If you want to for some ununderstandable reason disable auditing if auditd enabled it then you can set this option to false.
        It is of NixOS' opinion that setting this to false is definitely the wrong thing to do - but it's an option.
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

    services.journald.forwardToSyslog = lib.mkOption {
      default = config.services.rsyslogd.enable || config.services.syslog-ng.enable;
      defaultText = lib.literalExpression "services.rsyslogd.enable || services.syslog-ng.enable";
      type = lib.types.bool;
      description = ''
        Whether to forward log messages to syslog.
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

    environment.etc = {
      "systemd/journald.conf".text = ''
        [Journal]
        Storage=${cfg.storage}
        RateLimitInterval=${cfg.rateLimitInterval}
        RateLimitBurst=${toString cfg.rateLimitBurst}
        ${lib.optionalString (cfg.console != "") ''
          ForwardToConsole=yes
          TTYPath=${cfg.console}
        ''}
        ${lib.optionalString (cfg.forwardToSyslog) ''
          ForwardToSyslog=yes
        ''}
        Audit=${utils.systemdUtils.lib.toOption cfg.audit}
        ${cfg.extraConfig}
      '';
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
