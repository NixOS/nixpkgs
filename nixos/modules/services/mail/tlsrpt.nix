{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.tlsrpt;

  format = pkgs.formats.ini { };
  dropNullValues = lib.filterAttrsRecursive (_: value: value != null);

  commonServiceSettings = {
    DynamicUser = true;
    User = "tlsrpt";
    Restart = "always";
    StateDirectory = "tlsrpt";
    StateDirectoryMode = "0700";

    # Hardening
    CapabilityBoundingSet = [ "" ];
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    PrivateDevices = true;
    PrivateUsers = false;
    ProcSubset = "pid";
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "noaccess";
    RestrictNamespaces = true;
    RestrictRealtime = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged @resources"
    ];
  };

  collectdConfigFile = format.generate "tlsrpt-collectd.cfg" {
    tlsrpt_collectd = dropNullValues cfg.collectd.settings;
  };
  fetcherConfigFile = format.generate "tlsrpt-fetcher.cfg" {
    tlsrpt_fetcher = dropNullValues cfg.fetcher.settings;
  };
  reportdConfigFile = format.generate "tlsrpt-reportd.cfg" {
    tlsrpt_reportd = dropNullValues cfg.reportd.settings;
  };

  withPostfix = config.services.postfix.enable && cfg.configurePostfix;
in

{
  options.services.tlsrpt = {
    enable = mkEnableOption "the TLSRPT services";

    package = mkPackageOption pkgs "tlsrpt-reporter" { };

    collectd = {
      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;
          options = {
            storage = mkOption {
              type = types.str;
              default = "sqlite:///var/lib/tlsrpt/collectd.sqlite";
              description = ''
                Storage backend definition.
              '';
            };

            socketname = mkOption {
              type = types.path;
              default = "/run/tlsrpt/collectd.sock";
              description = ''
                Path at which the UNIX socket will be created.
              '';
            };

            socketmode = mkOption {
              type = types.str;
              default = "0220";
              description = ''
                Permissions on the UNIX socket.
              '';
            };

            log_level = mkOption {
              type = types.enum [
                "debug"
                "info"
                "warning"
                "error"
                "critical"
              ];
              default = "info";
              description = ''
                Level of log messages to emit.
              '';
            };
          };
        };
        default = { };
        description = ''
          Flags from {manpage}`tlsrpt-collectd(1)` as key-value pairs.
        '';
      };

      extraFlags = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          List of extra flags to pass to the tlsrpt-reportd executable.

          See {manpage}`tlsrpt-collectd(1)` for possible flags.
        '';
      };
    };

    fetcher = {
      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;
          options = {
            storage = mkOption {
              type = types.str;
              default = config.services.tlsrpt.collectd.settings.storage;
              defaultText = lib.literalExpression ''
                config.services.tlsrpt.collectd.settings.storage
              '';
              description = ''
                Path to the collectd sqlite database.
              '';
            };

            log_level = mkOption {
              type = types.enum [
                "debug"
                "info"
                "warning"
                "error"
                "critical"
              ];
              default = "info";
              description = ''
                Level of log messages to emit.
              '';
            };
          };
        };
        default = { };
        description = ''
          Flags from {manpage}`tlsrpt-fetcher(1)` as key-value pairs.
        '';
      };
    };

    reportd = {
      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;
          options = {
            dbname = mkOption {
              type = types.str;
              default = "/var/lib/tlsrpt/reportd.sqlite";
              description = ''
                Path to the sqlite database.
              '';
            };

            fetchers = mkOption {
              type = types.str;
              default = lib.getExe' cfg.package "tlsrpt-fetcher";
              defaultText = lib.literalExpression ''
                lib.getExe' cfg.package "tlsrpt-fetcher"
              '';
              description = ''
                Comma-separated list of fetcher programs that retrieve collectd data.
              '';
            };

            log_level = mkOption {
              type = types.enum [
                "debug"
                "info"
                "warning"
                "error"
                "critical"
              ];
              default = "info";
              description = ''
                Level of log messages to emit.
              '';
            };

            organization_name = mkOption {
              type = types.str;
              example = "ACME Corp.";
              description = ''
                Name of the organization sending out the reports.
              '';
            };

            contact_info = mkOption {
              type = types.str;
              example = "smtp-tls-reporting@example.com";
              description = ''
                Contact information embedded into the reports.
              '';
            };

            http_script = mkOption {
              type = with types; nullOr str;
              default = "${lib.getExe pkgs.curl} --silent --header 'Content-Type: application/tlsrpt+gzip' --data-binary @-";
              defaultText = lib.literalExpression ''
                ''${lib.getExe pkgs.curl} --silent --header 'Content-Type: application/tlsrpt+gzip' --data-binary @-
              '';
              description = ''
                Call to an HTTPS client, that accepts the URL on the commandline and the request body from stdin.
              '';
            };

            sender_address = mkOption {
              type = types.str;
              example = "noreply@example.com";
              description = ''
                Sender address used for reports.
              '';
            };

            sendmail_script = mkOption {
              type = with types; nullOr str;
              default =
                if config.services.postfix.enable && config.services.postfix.setSendmail then
                  "/run/wrappers/bin/sendmail -i -t"
                else
                  null;
              defaultText = lib.literalExpression ''
                if config.services.postfix.enable && config.services.postfix.setSendmail then
                  "/run/wrappers/bin/sendmail -i -t"
                else
                  null
              '';
              description = ''
                Path to a sendmail-compatible executable for delivery reports.
              '';
            };
          };
        };
        default = { };
        description = ''
          Flags from {manpage}`tlsrpt-reportd(1)` as key-value pairs.
        '';
      };

      extraFlags = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          List of extra flags to pass to the tlsrpt-reportd executable.

          See {manpage}`tlsrpt-report(1)` for possible flags.
        '';
      };
    };

    configurePostfix = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to configure permissions to allow integration with Postfix.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "tlsrpt/collectd.cfg".source = collectdConfigFile;
      "tlsrpt/fetcher.cfg".source = fetcherConfigFile;
      "tlsrpt/reportd.cfg".source = reportdConfigFile;
    };

    users.users.tlsrpt = {
      isSystemUser = true;
      group = "tlsrpt";
    };
    users.groups.tlsrpt = { };

    users.users.postfix.extraGroups = lib.mkIf withPostfix [
      "tlsrpt"
    ];

    systemd.services.tlsrpt-collectd = {
      description = "TLSRPT datagram collector";
      documentation = [ "man:tlsrpt-collectd(1)" ];

      wantedBy = [ "multi-user.target" ];

      restartTriggers = [ collectdConfigFile ];

      serviceConfig = commonServiceSettings // {
        ExecStart = toString (
          [
            (lib.getExe' cfg.package "tlsrpt-collectd")
          ]
          ++ cfg.collectd.extraFlags
        );
        IPAddressDeny = "any";
        PrivateNetwork = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RuntimeDirectory = "tlsrpt";
        RuntimeDirectoryMode = "0750";
        UMask = "0157";
      };
    };

    systemd.services.tlsrpt-reportd = {
      description = "TLSRPT report generator";
      documentation = [ "man:tlsrpt-reportd(1)" ];

      wantedBy = [ "multi-user.target" ];

      restartTriggers = [ reportdConfigFile ];

      serviceConfig = commonServiceSettings // {
        ExecStart = toString (
          [
            (lib.getExe' cfg.package "tlsrpt-reportd")
          ]
          ++ cfg.reportd.extraFlags
        );
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        ReadWritePaths = lib.optionals withPostfix [ "/var/lib/postfix/queue/maildrop" ];
        SupplementaryGroups = lib.optionals withPostfix [ "postdrop" ];
        UMask = "0077";
      };
    };
  };
}
