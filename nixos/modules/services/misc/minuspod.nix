{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.minuspod;
in
{
  options = {
    services.minuspod = {
      enable = lib.mkEnableOption "MinusPod, self-hosted podcast ad-removal server";

      package = lib.mkPackageOption pkgs "minuspod" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "minuspod";
        description = "User account under which MinusPod runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "minuspod";
        description = "Group under which MinusPod runs.";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "minuspod";
        description = ''
          Path to MinusPod data (SQLite DB, downloads, cache) inside of /var/lib.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          Host address which MinusPod listens on.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        description = ''
          TCP port MinusPod listens on.
        '';
      };

      baseUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:8000";
        example = "https://podcasts.example.com";
        description = ''
          Public URL for generated feed links (`BASE_URL`).
          Should match the externally reachable address.
        '';
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          LLM_PROVIDER = "ollama";
          OPENAI_BASE_URL = "http://127.0.0.1:11434/v1";
          OPENAI_MODEL = "qwen3:14b";
          WHISPER_BACKEND = "openai-api";
          WHISPER_API_BASE_URL = "https://api.groq.com/openai/v1";
        };
        description = ''
          Extra environment variables for MinusPod.
          Secrets should prefer `environmentFile`.
          See <https://github.com/ttlequals0/MinusPod/blob/main/docs/environment-variables.md>
          and `.env.example` for all options (`LLM_PROVIDER`,
          `ANTHROPIC_API_KEY`, `OPENROUTER_API_KEY`, `OPENAI_BASE_URL`,
          `OPENAI_MODEL`, `WHISPER_MODEL`, `WHISPER_BACKEND`, ...).
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/secrets/minuspod.env";
        description = ''
          Environment file with secrets (e.g. `ANTHROPIC_API_KEY`,
          `OPENROUTER_API_KEY`, `MINUSPOD_MASTER_PASSPHRASE`,
          `MINUSPOD_SETUP_TOKEN`), passed to systemd via `EnvironmentFile`.
          Useful to prevent secrets from being world-readable in the Nix store.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the MinusPod web interface and feeds.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.minuspod = {
      description = "MinusPod podcast ad-removal server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        DATA_DIR = "/var/lib/${cfg.dataDir}";
        MINUSPOD_DATA_DIR = "/var/lib/${cfg.dataDir}";
        HOME = "/var/lib/${cfg.dataDir}";
        HF_HOME = "/var/lib/${cfg.dataDir}/.cache";
        HUGGINGFACE_HUB_CACHE = "/var/lib/${cfg.dataDir}/.cache/hub";
        XDG_CACHE_HOME = "/var/lib/${cfg.dataDir}/.cache";
        BASE_URL = cfg.baseUrl;
        MINUSPOD_PORT = toString cfg.port;
        GUNICORN_BIND = "${cfg.host}:${toString cfg.port}";
      }
      // cfg.environment;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = cfg.dataDir;
        WorkingDirectory = "/var/lib/${cfg.dataDir}";
        ExecStart = "${lib.getExe cfg.package}";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        Restart = "on-failure";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        CapabilityBoundingSet = "";
        UMask = "0027";
      };
    };

    users.users = lib.mkIf (cfg.user == "minuspod") {
      minuspod = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${cfg.dataDir}";
        description = "MinusPod service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "minuspod") {
      minuspod = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ tlvince ];
}
