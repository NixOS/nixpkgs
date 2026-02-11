{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    filterAttrsRecursive
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    ;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.services.routinator;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.routinator = {
    enable = mkEnableOption "Routinator 3000";

    package = mkPackageOption pkgs "routinator" { };

    extraArgs = mkOption {
      description = ''
        Extra arguments passed to routinator, see <https://routinator.docs.nlnetlabs.nl/en/stable/manual-page.html#options> for options.";
      '';
      type = types.listOf types.str;
      default = [ ];
      example = [ "--no-rir-tals" ];
    };

    extraServerArgs = mkOption {
      description = ''
        Extra arguments passed to the server subcommand, see <https://routinator.docs.nlnetlabs.nl/en/stable/manual-page.html#subcmd-server> for options.";
      '';
      type = types.listOf types.str;
      default = [ ];
      example = [ "--rtr-client-metrics" ];
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          repository-dir = mkOption {
            type = types.path;
            description = ''
              The path where the collected RPKI data is stored.
            '';
            default = "/var/lib/routinator/rpki-cache";
          };
          log-level = mkOption {
            type = types.nullOr (
              types.enum [
                "error"
                "warn"
                "info"
                "debug"
              ]
            );
            description = ''
              A string value specifying the maximum log level for which log messages should be emitted.
              See, <https://routinator.docs.nlnetlabs.nl/en/stable/manual-page.html#logging>
            '';
            default = "warn";
          };
          log = mkOption {
            type = types.nullOr (
              types.enum [
                "default"
                "stderr"
                "syslog"
                "file"
              ]
            );
            description = ''
              A string specifying where to send log messages to.
              See, <https://routinator.docs.nlnetlabs.nl/en/stable/manual-page.html#term-log>
            '';
            default = "default";
          };
          log-file = mkOption {
            type = types.nullOr types.path;
            description = ''
              A string value containing the path to a file to which log messages will be appended if the log configuration value is set to file. In this case, the value is mandatory.
            '';
            default = null;
          };
          http-listen = mkOption {
            type = types.nullOr (types.listOf types.str);
            description = ''
              An array of string values each providing an address and port on which the HTTP server should listen. Address and port should be separated by a colon. IPv6 address should be enclosed in square brackets.
            '';
            default = null;
          };
          rtr-listen = mkOption {
            type = types.nullOr (types.listOf types.str);
            description = ''
              An array of string values each providing an address and port on which the RTR server should listen in TCP mode. Address and port should be separated by a colon. IPv6 address should be enclosed in square brackets.
            '';
            default = null;
          };
          refresh = mkOption {
            type = types.nullOr types.int;
            description = ''
              An integer value specifying the number of seconds Routinator should wait between consecutive validation runs in server mode. The next validation run will happen earlier, if objects expire earlier.
            '';
            default = 600;
          };
          retry = mkOption {
            type = types.nullOr types.int;
            description = ''
              An integer value specifying the number of seconds an RTR client is requested to wait after it failed to receive a data set.
            '';
            default = 600;
          };
          expire = mkOption {
            type = types.nullOr types.int;
            description = ''
              An integer value specifying the number of seconds an RTR client is requested to use a data set if it cannot get an update before throwing it away and continuing with no data at all.
            '';
            default = 7200;
          };
        };
      };
      description = ''
        Configuration for Routinator 3000, see <https://routinator.docs.nlnetlabs.nl/en/stable/manual-page.html#configuration-file> for options.
      '';
      default = { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.routinator = {
      description = "Routinator 3000 is free, open-source RPKI Relying Party software made by NLnet Labs.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [ rsync ];
      serviceConfig = {
        Type = "exec";
        ExecStart = escapeSystemdExecArgs (
          [
            (getExe cfg.package)
            "--config=${
              settingsFormat.generate "routinator.conf" (filterAttrsRecursive (n: v: v != null) cfg.settings)
            }"
          ]
          ++ cfg.extraArgs
          ++ [
            "server"
          ]
          ++ cfg.extraServerArgs
        );
        Restart = "on-failure";
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        StateDirectory = "routinator";
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
        UMask = "0027";
      };
    };
  };

  meta.maintainers = with maintainers; [ xgwq ];
}
