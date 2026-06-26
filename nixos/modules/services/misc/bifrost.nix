{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.bifrost;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.bifrost = {
    enable = lib.mkEnableOption "Bifrost, a high-performance LLM gateway with native MCP support";

    package = lib.mkPackageOption pkgs "bifrost" { };

    stateDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/bifrost";
      example = "/var/lib/bifrost";
      description = ''
        Application data directory (contains `config.json` and logs).
        Must be a direct child of `/var/lib` so it works with systemd's
        `StateDirectory=` and `DynamicUser=`.
      '';
    };

    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Address Bifrost listens on.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 8080;
      example = 11111;
      description = "Port Bifrost listens on.";
    };

    logLevel = lib.mkOption {
      type = types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = "Logger verbosity.";
    };

    logStyle = lib.mkOption {
      type = types.enum [
        "json"
        "pretty"
      ];
      default = "json";
      description = "Logger output style.";
    };

    settings = lib.mkOption {
      type = types.nullOr settingsFormat.type;
      default = null;
      example = {
        providers = [
          {
            name = "openai";
            enabled = true;
            keys = [
              {
                name = "default";
                value = "env.OPENAI_API_KEY";
              }
            ];
          }
        ];
      };
      description = ''
        Optional content for `config.json` under {option}`services.bifrost.stateDir`.

        When set, the file is written on service start, overwriting any existing
        `config.json`. When `null`, Bifrost uses an existing `config.json` or
        bootstraps from environment variables / the admin UI.
      '';
    };

    environment = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        OPENAI_API_KEY = "...";
      };
      description = "Extra environment variables for the Bifrost service.";
    };

    environmentFile = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/bifrost.env";
      description = ''
        Environment file passed to the systemd service. Useful for passing
        provider API keys without making them world-readable in the Nix store.
      '';
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Open {option}`services.bifrost.port` in the firewall.";
    };

    extraArgs = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "-some-flag"
        "value"
      ];
      description = "Extra CLI arguments passed to `bifrost-http`.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.dirOf (toString cfg.stateDir) == "/var/lib";
        message = "services.bifrost.stateDir must be a direct child of /var/lib (e.g. /var/lib/bifrost) to work with systemd StateDirectory and DynamicUser.";
      }
    ];

    systemd.services.bifrost =
      let
        stateDirStr = toString cfg.stateDir;
        configFile =
          if cfg.settings == null then null else settingsFormat.generate "bifrost-config.json" cfg.settings;
      in
      {
        description = "Bifrost LLM gateway";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment = cfg.environment;

        preStart = lib.optionalString (configFile != null) ''
          install -Dm600 "${configFile}" "${stateDirStr}/config.json"
        '';

        serviceConfig = {
          ExecStart = lib.concatStringsSep " " (
            [
              (lib.getExe cfg.package)
              "-host"
              cfg.host
              "-port"
              (toString cfg.port)
              "-app-dir"
              stateDirStr
              "-log-level"
              cfg.logLevel
              "-log-style"
              cfg.logStyle
            ]
            ++ cfg.extraArgs
          );

          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

          WorkingDirectory = cfg.stateDir;
          StateDirectory = builtins.baseNameOf stateDirStr;
          RuntimeDirectory = "bifrost";
          RuntimeDirectoryMode = "0755";

          DynamicUser = true;
          DevicePolicy = "closed";
          LockPersonality = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
        };
      };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ ManUtopiK ];
}
