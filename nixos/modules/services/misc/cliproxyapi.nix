{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.cliproxyapi;
  format = pkgs.formats.yaml { };
  stateDir = "/var/lib/cliproxyapi";
  configPath = "${stateDir}/config.yaml";
  settings = {
    auth-dir = stateDir;
  }
  // cfg.settings;
  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } settings configPath;
  port = cfg.settings.port or 8317;
in
{
  options.services.cliproxyapi = {
    enable = lib.mkEnableOption "CLIProxyAPI";

    package = lib.mkPackageOption pkgs "cliproxyapi" { };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      example = lib.literalExpression ''
        {
          host = "127.0.0.1";
          port = 8317;
          api-keys = [ { _secret = "/run/secrets/cliproxyapi-api-key"; } ];
          remote-management.secret-key._secret = "/run/secrets/cliproxyapi-management-key";
        }
      '';
      description = ''
        Configuration for CLIProxyAPI. See the
        [example configuration](https://github.com/router-for-me/CLIProxyAPI/blob/main/config.example.yaml)
        for available options. Secret values can be loaded from files using
        `._secret = "/path/to/secret";`.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/cliproxyapi.env";
      description = "Environment file as defined in {manpage}`systemd.exec(5)`.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "cliproxyapi";
      description = "User account under which CLIProxyAPI runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "cliproxyapi";
      description = "Group under which CLIProxyAPI runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "cliproxyapi") {
      cliproxyapi = {
        isSystemUser = true;
        group = cfg.group;
        home = stateDir;
        description = "CLIProxyAPI service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "cliproxyapi") {
      cliproxyapi = { };
    };

    systemd.services.cliproxyapi = {
      description = "Proxy that provides OpenAI/Gemini/Claude/Codex/Grok compatible API interfaces";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = secretsReplacement.script;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "cliproxyapi";
        StateDirectoryMode = "0700";
        WorkingDirectory = stateDir;
        ExecStart = "${lib.getExe cfg.package} -config ${configPath}";
        Restart = "on-failure";
        RestartSec = 5;
        LoadCredential = secretsReplacement.credentials;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RemoveIPC = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ port ];
    };
  };

  meta.maintainers = [ lib.maintainers.anish ];
}
