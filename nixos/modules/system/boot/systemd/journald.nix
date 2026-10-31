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
    (lib.mkRenamedOptionModule
      [ "services" "journald" "audit" ]
      [ "services" "journald" "settings" "Journal" "Audit" ]
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
      };
    };
    services.journald.namespaces = lib.mkOption {
      default = { };
      example = {
        postfix.settings.Journal = {
          Storage = "persistent";
          MaxRetentionSec = "14day";
        };
      };
      description = ''
        Options for systemd journal namespaces. See "Journal Namespaces"
        section of {manpage}`systemd-journald.service(8)`.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.settings.Journal = lib.mkOption {
            default = { };
            example = {
              Storage = "volatile";
            };
            description = ''
              Options for this journal namespace. See {manpage}`journald.conf(5)`
              man page for available options.
            '';
            type = lib.types.submodule {
              freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
            };
          };
        }
      );
    };
  };

  config = {
    assertions = lib.mapAttrsToList (name: _: {
      assertion = builtins.match "[A-Za-z0-9:_.-]+" name != null;
      message = "services.journald.namespaces: `${name}` is not a valid journal namespace name. Must match this regex [A-Za-z0-9:_.-]+";
    }) cfg.namespaces;

    services.journald.settings.Journal = {
      # "keep" isn't systemd's default since v258, so set it explicitly.
      Audit = lib.mkOptionDefault "keep";
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
      "systemd-journalctl.socket"
      "systemd-journalctl@.service"
      "syslog.socket"
    ];

    systemd.sockets.systemd-journald-audit.wantedBy = [
      "systemd-journald.service"
      "sockets.target"
    ];

    environment.etc = {
      "systemd/journald.conf".text = utils.systemdUtils.lib.settingsToSections cfg.settings;
    }
    // lib.mapAttrs' (
      name: ns:
      lib.nameValuePair "systemd/journald@${name}.conf" {
        text = utils.systemdUtils.lib.settingsToSections ns.settings;
      }
    ) cfg.namespaces;

    users.groups.systemd-journal.gid = config.ids.gids.systemd-journal;

    systemd.services = {
      systemd-journal-flush.restartIfChanged = false;
      systemd-journald.restartTriggers = [
        config.environment.etc."systemd/journald.conf".source
      ];
      systemd-journald.stopIfChanged = false;
      "systemd-journald@".stopIfChanged = false;
    }
    # Namespaced instances only read journald@<name>.conf (plus drop-ins),
    # never journald.conf, so trigger restarts on their own file.
    // lib.mapAttrs' (
      name: _:
      lib.nameValuePair "systemd-journald@${name}" {
        overrideStrategy = "asDropin";
        restartTriggers = [
          config.environment.etc."systemd/journald@${name}.conf".source
        ];
      }
    ) cfg.namespaces;
  };
}
