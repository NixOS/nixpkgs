{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.nanobot;

  # Always /var/lib/<name> so systemd's StateDirectory owns the directory.
  stateDir = "/var/lib/${cfg.stateDirectoryName}";

  jsonFormat = pkgs.formats.json { };

  configJson = jsonFormat.generate "nanobot-config.json" (
    lib.recursiveUpdate {
      # Since v0.3.0 the user-facing WebUI/WebSocket listener is
      # `channels.websocket`; the internal `gateway` control port
      # (loopback, default 18790) serves GET /health.
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
        Note: upstream refuses to bind {literal}`0.0.0.0` unless
        `channels.websocket.token` or `channels.websocket.tokenIssueSecret`
        is configured.
      '';
    };

    port = lib.mkOption {
      type = types.port;
      default = 8765;
      description = ''
        TCP port the nanobot WebSocket channel (WebUI) listens on. The
        unauthenticated health endpoint is served separately by the
        internal `gateway` listener on loopback (default port 18790,
        configurable via `settings.gateway.port`).
      '';
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Additional nanobot configuration written to {file}`config.json`,
        deep-merged on top of the {option}`services.nanobot.host` and
        {option}`services.nanobot.port` `channels.websocket` settings.
        Note: the generated file is stored world-readable in the Nix
        store, so put secrets in {option}`services.nanobot.environmentFile`
        and reference them as `''${VAR}` placeholders here instead. The
        config is reinstalled from this declaration on every service
        (re)start, reverting changes made at runtime via the WebUI.
        See <https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md>
        for the available options (providers, model presets, channels, ...).
      '';
    };

    environmentFile = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/nanobot";
      description = ''
        Environment file loaded by the systemd service.

        nanobot resolves `''${VAR}` placeholders in
        {option}`services.nanobot.settings` from the process environment at
        startup, so put secrets here (e.g. `OPENAI_API_KEY=sk-...`) and
        reference them in the config as `"apiKey": "''${OPENAI_API_KEY}"`.
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
      };

      serviceConfig = {
        # v0.3.0 derives its runtime data dir (cron/, logs/, media/, ...) from
        # the config file's parent directory, so the config must live in the
        # writable state directory, not in the Nix store.
        ExecStartPre =
          "${pkgs.coreutils}/bin/install -m 0600 ${configJson} ${stateDir}/config.json";
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
