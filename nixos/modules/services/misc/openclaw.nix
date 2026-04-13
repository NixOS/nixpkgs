{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openclaw;
  openclaw = lib.getExe cfg.package;

  configFormat = pkgs.formats.json { };
  configFile = configFormat.generate "openclaw.json" cfg.settings;
in
{
  options = {
    services.openclaw = {
      enable = lib.mkEnableOption "openclaw AI assistant gateway";
      package = lib.mkPackageOption pkgs "openclaw" { };

      port = lib.mkOption {
        type = lib.types.port;
        default = 18789;
        description = ''
          Port for the openclaw WebSocket gateway.
        '';
      };

      auth = lib.mkOption {
        type = lib.types.enum [
          "none"
          "token"
          "password"
        ];
        default = "none";
        description = ''
          Authentication mode for the gateway.
        '';
      };

      tokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File containing the gateway auth token (for auth = "token").
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File containing the gateway password (for auth = "password").
        '';
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/openclaw";
        description = ''
          State directory for openclaw.
        '';
      };

      settings = lib.mkOption {
        type = configFormat.type;
        default = { };
        description = ''
          Configuration written to openclaw.json.
          See `openclaw config schema` for available options.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the firewall for the openclaw gateway port.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.openclaw = {
      description = "OpenClaw AI assistant gateway";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        HOME = cfg.stateDir;
        OPENCLAW_STATE_DIR = cfg.stateDir;
        OPENCLAW_CONFIG_PATH = "${cfg.stateDir}/openclaw.json";
        NODE_ENV = "production";
      };

      preStart = ''
        mkdir -p ${cfg.stateDir}
        # Merge provided settings into config, preserving any runtime state
        if [ -f ${cfg.stateDir}/openclaw.json ]; then
          ${lib.getExe pkgs.jq} -s '.[0] * .[1]' ${cfg.stateDir}/openclaw.json ${configFile} > ${cfg.stateDir}/openclaw.json.tmp
          mv ${cfg.stateDir}/openclaw.json.tmp ${cfg.stateDir}/openclaw.json
        else
          cp ${configFile} ${cfg.stateDir}/openclaw.json
          chmod 600 ${cfg.stateDir}/openclaw.json
        fi
      '';

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        ExecStart =
          let
            authArgs =
              if cfg.auth == "token" && cfg.tokenFile != null then
                "--auth token --token \"$(cat ${cfg.tokenFile})\""
              else if cfg.auth == "password" && cfg.passwordFile != null then
                "--auth password --password-file ${cfg.passwordFile}"
              else if cfg.auth == "none" then
                "--auth none"
              else
                "--auth ${cfg.auth}";
          in
          "${openclaw} gateway run --port ${toString cfg.port} ${authArgs}";
        WorkingDirectory = cfg.stateDir;
        StateDirectory = [ "openclaw" ];
        ReadWritePaths = [ cfg.stateDir ];
        Restart = "on-failure";
        RestartSec = "5s";

        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [
    mkg20001
  ];
}
