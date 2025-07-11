{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nezha;

  # nezha uses yaml as the configuration file format.
  # Since we need to use jq to update the content, so here we generate json
  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "config.json" cfg.settings;
in
{
  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };
  options = {
    services.nezha = {
      enable = lib.mkEnableOption "Nezha Monitoring";

      package = lib.mkPackageOption pkgs "nezha" { };

      debug = lib.mkEnableOption "verbose log";

      settings = lib.mkOption {
        description = ''
          Generate to {file}`config.yaml` as a Nix attribute set.
          Check the [guide](https://nezha.wiki/en_US/guide/dashboard.html)
          for possible options.
        '';
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            listenhost = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = ''
                Host on which the nezha web interface and grpc should listen
              '';
            };
            listenport = lib.mkOption {
              type = lib.types.port;
              default = 8008;
              description = ''
                Port on which the nezha web interface and grpc should listen
              '';
            };

          };
        };
      };

      mutableConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether the config.yaml is writeable by Nezha.

          If this option is disabled, changes on the web interface won't
          be possible. If an config.yaml is present, it will be overwritten.
        '';
      };

      jwtSecretFile = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = ''
          Path to the file containing the secret to sign web requests using JSON Web Tokens.
        '';
      };

      agentSecretFile = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = ''
          Path to the file containing the secret used by agents to connect.
        '';
      };

      extraThemes = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.nezha-theme-nazhua ]";
        description = ''
          A list of additional themes.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.nezha.settings = {
      debug = cfg.debug;
    };

    systemd.services.nezha = {
      serviceConfig = {
        Restart = "on-failure";
        StateDirectory = "nezha";
        RuntimeDirectory = "nezha";
        ConfigurationDirectory = "nezha";
        WorkingDirectory = "/var/lib/nezha";
        ReadWritePaths = [
          "/var/lib/nezha"
          "/etc/nezha"
        ];

        LoadCredential = [
          "jwt-secret:${cfg.jwtSecretFile}"
          "agent-secret:${cfg.agentSecretFile}"
        ];

        # Hardening
        ProcSubset = "pid";
        DynamicUser = true;
        RemoveIPC = true;
        LockPersonality = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = cfg.settings.listenport >= 1024; # incompatible with CAP_NET_BIND_SERVICE
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = lib.optionalString (cfg.settings.listenport < 1024) "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = lib.optionalString (cfg.settings.listenport < 1024) "CAP_NET_BIND_SERVICE";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0066";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        PrivateDevices = "yes";

        ExecStart =
          let
            package = cfg.package.override { withThemes = cfg.extraThemes; };
          in
          ''${lib.getExe package} -c "''${CONFIGURATION_DIRECTORY}"/config.yaml -db "''${STATE_DIRECTORY}"/sqlite.db'';
      };
      enableStrictShellChecks = true;
      startLimitIntervalSec = 10;
      startLimitBurst = 3;
      preStart = ''
        cp "${configFile}" "''${RUNTIME_DIRECTORY}"/new
        ${lib.getExe pkgs.jq} \
            --arg jwt_secret "$(<"''${CREDENTIALS_DIRECTORY}"/jwt-secret)" \
            --arg agent_secret "$(<"''${CREDENTIALS_DIRECTORY}"/agent-secret)" \
            '. + { jwtsecretkey: $jwt_secret, agentsecretkey: $agent_secret }' \
            < "''${RUNTIME_DIRECTORY}"/new > "''${RUNTIME_DIRECTORY}"/tmp
        mv "''${RUNTIME_DIRECTORY}"/tmp "''${RUNTIME_DIRECTORY}"/new

        ${lib.optionalString cfg.mutableConfig ''
          [ -e "''${CONFIGURATION_DIRECTORY}"/config.yaml ] && \
            ${lib.getExe pkgs.yj} < "''${CONFIGURATION_DIRECTORY}"/config.yaml > "''${RUNTIME_DIRECTORY}"/old && \
            ${lib.getExe pkgs.jq} -s '.[0] * .[1]' \
              "''${RUNTIME_DIRECTORY}"/old "''${RUNTIME_DIRECTORY}"/new > "''${RUNTIME_DIRECTORY}"/tmp
          [ -e "''${RUNTIME_DIRECTORY}"/old ] && rm "''${RUNTIME_DIRECTORY}"/old
          [ -e "''${RUNTIME_DIRECTORY}"/tmp ] && mv "''${RUNTIME_DIRECTORY}"/tmp "''${RUNTIME_DIRECTORY}"/new
        ''}
        mv "''${RUNTIME_DIRECTORY}"/new  "''${CONFIGURATION_DIRECTORY}"/config.yaml
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };
}
