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

      configurePostfix = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to modify the local Postfix service to grant access to the collectd socket.
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

            sender_address = mkOption {
              type = types.str;
              example = "noreply@example.com";
              description = ''
                Sender address used for reports.
              '';
            };

            sendmail_script = mkOption {
              type = with types; nullOr str;
              default = if config.services.postfix.enable then "sendmail" else null;
              defaultText = lib.literalExpression ''
                if any [ config.services.postfix.enable ] then "sendmail" else null
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
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "tlsrpt/collectd.cfg".source = format.generate "tlsrpt-collectd.cfg" {
        tlsrpt_collectd = dropNullValues cfg.collectd.settings;
      };
      "tlsrpt/fetcher.cfg".source = format.generate "tlsrpt-fetcher.cfg" {
        tlsrpt_fetcher = dropNullValues cfg.fetcher.settings;
      };
      "tlsrpt/reportd.cfg".source = format.generate "tlsrpt-reportd.cfg" {
        tlsrpt_reportd = dropNullValues cfg.reportd.settings;
      };
    };

    systemd.services.postfix.serviceConfig.SupplementaryGroups = mkIf (
      config.services.postfix.enable && cfg.collectd.configurePostfix
    ) [ "tlsrpt" ];

    systemd.services.tlsrpt-collectd = {
      description = "TLSRPT datagram collector";
      documentation = [ "man:tlsrpt-collectd(1)" ];

      wantedBy = [ "multi-user.target" ];

      restartTriggers = [ "/etc/tlsrpt/collectd.cfg" ];

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

      restartTriggers = [ "/etc/tlsrpt/reportd.cfg" ];

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
        ];
        UMask = "0077";
      };
    };
  };
}
