{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.zeroclaw;

  format = pkgs.formats.toml { };
  configPath = "${cfg.stateDir}/config.toml";
  jsonConfigPath = "/run/zeroclaw/config.json";

  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.settings jsonConfigPath;
in
{
  meta.maintainers = with lib.maintainers; [
    drupol
    nixosclaw
  ];

  options.services.zeroclaw = {
    enable = lib.mkEnableOption "ZeroClaw agent daemon";

    package = lib.mkPackageOption pkgs "zeroclaw" { };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/zeroclaw";
      description = ''
        Directory for ZeroClaw runtime state.
        The `config.toml` is written here on service start when
        {option}`mutableConfig` is disabled.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host the gateway binds to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 42617;
      description = "Port the gateway listens on.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "zeroclaw";
      description = "User account the daemon runs as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "zeroclaw";
      description = "Group the daemon runs as.";
    };

    mutableConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When false (default), `config.toml` is regenerated from
        {option}`settings` on every service start.

        When true, `config.toml` is written only on first start (if it does not
        already exist), allowing runtime edits made through the web UI or CLI
        to persist across restarts.
      '';
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration serialized as TOML into `config.toml`.
        Secret values can be loaded from files using `._secret = "/path/to/secret";`
        so they are injected via systemd `LoadCredential=` at startup without
        entering the Nix store.
      '';
      example = lib.literalExpression ''
        {
          default_provider = "ollama";
          default_model = "qwen3-coder-next:q4_K_M";
          api_url = "http://127.0.0.1:11434";
          api_key._secret = "/run/secrets/zeroclaw-api-key";
          memory.backend = "sqlite";
        }
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/zeroclaw.env";
      description = "Environment file as defined in {manpage}`systemd.exec(5)`.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for {option}`services.zeroclaw.port`.";
    };

    web.nginx.virtualHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Hostname of the nginx virtualHost to proxy to the ZeroClaw daemon.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0700 ${cfg.user} ${cfg.group} -"
      "d ${cfg.stateDir}/workspace 0700 ${cfg.user} ${cfg.group} -"
    ];

    users.users.${cfg.user} = lib.mkIf (cfg.user == "zeroclaw") {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      createHome = false;
      description = "ZeroClaw agent daemon user";
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == "zeroclaw") { };

    systemd.services.zeroclaw = {
      description = "ZeroClaw Agent Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        ZEROCLAW_CONFIG_DIR = cfg.stateDir;
        ZEROCLAW_GATEWAY_HOST = cfg.host;
        ZEROCLAW_GATEWAY_PORT = toString cfg.port;
      }
      // lib.optionalAttrs (cfg.host != "127.0.0.1" && cfg.host != "localhost" && cfg.host != "::1") {
        ZEROCLAW_ALLOW_PUBLIC_BIND = "1";
      };

      preStart = ''
        ${lib.optionalString cfg.mutableConfig ''
          if [ -f ${lib.escapeShellArg configPath} ]; then
            echo "zeroclaw: mutableConfig is enabled and config.toml already exists, skipping update"
            exit 0
          fi
        ''}
        (
          umask 0077
          ${secretsReplacement.script}
          ${pkgs.remarshal}/bin/json2toml ${lib.escapeShellArg jsonConfigPath} ${lib.escapeShellArg configPath}
          chmod 0600 ${lib.escapeShellArg configPath}
          rm -f ${lib.escapeShellArg jsonConfigPath}
        )
      '';

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;

        ExecStart = "${lib.getExe cfg.package} daemon";
        WorkingDirectory = cfg.stateDir;
        RuntimeDirectory = "zeroclaw";
        RuntimeDirectoryMode = "0700";

        LoadCredential = secretsReplacement.credentials;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.stateDir ];
        CapabilityBoundingSet = "";
        LockPersonality = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";

        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    services.nginx.virtualHosts = lib.mkIf (cfg.web.nginx.virtualHost != null) {
      ${cfg.web.nginx.virtualHost} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
          '';
        };
      };
    };
  };
}
