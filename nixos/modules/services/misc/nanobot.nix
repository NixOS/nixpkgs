{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.nanobot;

  stateDir = "/var/lib/${cfg.stateDirectoryName}";

  jsonFormat = pkgs.formats.json { };

  configJson = jsonFormat.generate "nanobot-config.json" (
    lib.recursiveUpdate {
      channels.websocket = {
        inherit (cfg) host port;
      };
    } cfg.settings
  );
in
{
  options.services.nanobot = {
    enable = lib.mkEnableOption "nanobot gateway daemon";

    package = lib.mkPackageOption pkgs "nanobot" { };

    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        Address the nanobot WebSocket channel (WebUI and chat) binds to.
        Upstream refuses to bind `0.0.0.0` unless
        `channels.websocket.token` or `channels.websocket.tokenIssueSecret`
        is configured.
      '';
    };

    port = lib.mkOption {
      type = types.port;
      default = 8765;
      description = ''
        TCP port the nanobot WebSocket channel (WebUI) listens on.
      '';
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Additional nanobot configuration written to {file}`config.json` (deep-merged.
        See <https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md>
      '';
    };

    environmentFile = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/nanobot";
      description = ''
        Environment file loaded by the systemd service.
      '';
    };

    stateDirectoryName = lib.mkOption {
      type = types.strMatching "[A-Za-z0-9_-]+";
      default = "nanobot";
      description = ''
        Name of the subdirectory under {file}`/var/lib` used as nanobot's
        workspace and home.
      '';
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the nanobot gateway, adding
        {option}`services.nanobot.port` to
        {option}`networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nanobot = {
      description = "nanobot lightweight AI agent gateway";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = {
        HOME = stateDir;
        XDG_DATA_HOME = "${stateDir}/.local/share";
        XDG_CONFIG_HOME = "${stateDir}/.config";
        PYTHONNOUSERSITE = "1";
      };

      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/install -m 0600 ${configJson} ${stateDir}/config.json";
        ExecStart = "${lib.getExe cfg.package} gateway --config ${stateDir}/config.json";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = stateDir;
        StateDirectory = cfg.stateDirectoryName;
        RuntimeDirectory = "nanobot";
        RuntimeDirectoryMode = "0755";
        DynamicUser = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProtectClock = true;
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        CapabilityBoundingSet = "";
        UMask = "0077";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ gdifolco ];
}
