{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    types
    ;
  cfg = config.services.pushlog;
  settingsFormat = pkgs.formats.yaml { };
  unitType = types.submodule {
    options = {
      match = mkOption {
        type = types.str;
        default = ".*";
        description = "Regex pattern to match against the systemd unit name";
      };
      priorities = mkOption {
        type = types.listOf types.int;
        default = lib.lists.range 0 6; # exclude debug
        description = "List of journald priorities to include (0-7)";
      };
      include = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of regex patterns to match in message content (empty matches all)";
      };
      exclude = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of regex patterns to exclude from matches";
      };
    };
  };
in
{
  options.services.pushlog = {
    enable = mkEnableOption "pushlog service to forward journald logs to Pushover";

    package = mkPackageOption pkgs "pushlog" { };

    environmentFile = mkOption {
      type = with types; nullOr str;
      description = lib.mdDoc ''
        File containing the Pushover API credentials, in the
        format of an EnvironmentFile as described in systemd.exec(5)

        PUSHLOG_PUSHOVER_TOKEN, PUSHLOG_PUSHOVER_USER_KEY
      '';
      default = null;
    };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          collect-timeout = mkOption {
            type = types.int;
            description = "Wait n seconds before sendings logs to bundle multiple messages";
            default = 5;
          };
          deduplication-window = mkOption {
            type = types.int;
            description = "Remember messages for n minutes and avoid sending duplicates";
            default = 30;
          };
          fuzzy-threshold = mkOption {
            type = types.int;
            description = "Use fuzzy matching with the given threshold (similarity in percent) to detect duplicates, set to 100 to disable";
            default = 95;
          };
          title = mkOption {
            type = with types; nullOr str;
            description = "Optional title to use for all Pushover notifications";
            default = null;
          };
          priority-map = mkOption {
            type = with types; attrsOf (ints.between (-2) 2);
            description = "Optional mapping from journald priorities (0-7) to Pushover priorities (-2, -1, 0, 1, 2), unmapped priorities will be mapped to 0";
            default = { };
            example = literalExpression ''
              {
                "0" = 2;  # emerg -> emergency (2)
                "1" = 1;  # alert -> high (1)
                "2" = 1;  # crit -> high (1)
                "3" = 0;  # err -> normal (0)
                "4" = -1; # warning -> low (-1)
                "5" = -2; # notice -> lowest (-2)
                "6" = -2; # info -> lowest (-2)
                "7" = -2; # debug -> lowest (-2)
              }
            '';
          };
          units = mkOption {
            type = types.listOf unitType;
            description = "List of units to care about";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable (
    let
      format = pkgs.formats.yaml { };
      configFile = format.generate "pushlog.yaml" cfg.settings;
    in
    {
      systemd.services.pushlog = {
        description = "Pushlog journal forwarder";
        requires = [
          "network-online.target"
          "systemd-journald.service"
        ];
        after = [
          "network-online.target"
          "systemd-journald.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig =
          {
            ExecStart = "${getExe cfg.package} --config ${configFile}";
            Type = "simple";
            Restart = "always";
            RestartSec = "5s";

            # Hardening
            CapabilityBoundingSet = "";
            DynamicUser = true;
            Group = "systemd-journal";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "noaccess";
            ProtectSystem = "strict";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallFilter = "~@aio @chown @clock @cpu-emulation @debug @keyring @ipc @module @mount @obsolete @raw-io @reboot @setuid @swap @privileged @resources";
            UMask = "0077";
          }
          // optionalAttrs (cfg.environmentFile != null) {
            EnvironmentFile = cfg.environmentFile;
          };
      };
    }
  );

  meta = {
    maintainers = with lib.maintainers; [ serpent213 ];
    doc = ./pushlog.md;
  };
}
