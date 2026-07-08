{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.bouncarr;
  format = pkgs.formats.yaml { };
  stateDir = "/var/lib/bouncarr";
  # Bouncarr only reads config.yaml from its working directory
  configPath = "${stateDir}/config.yaml";
  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.settings configPath;
  port = lib.attrByPath [ "server" "port" ] 3000 cfg.settings;
in
{
  options.services.bouncarr = {
    enable = lib.mkEnableOption "bouncarr";

    package = lib.mkPackageOption pkgs "bouncarr" { };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      example = lib.literalExpression ''
        {
          jellyfin = {
            url = "http://localhost:8096";
            api_key._secret = "/run/secrets/bouncarr-jellyfin-api-key";
          };
          arr_apps = [
            {
              name = "sonarr";
              url = "http://localhost:8989";
            }
            {
              name = "radarr";
              url = "http://localhost:7878";
            }
          ];
          server.port = 3000;
          security.secure_cookies = true;
        }
      '';
      description = ''
        Configuration for bouncarr. See the
        [example configuration](https://github.com/teknostom/bouncarr/blob/master/config.example.yaml)
        for available options. Secret values can be loaded from files using
        `._secret = "/path/to/secret";`.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/bouncarr.env";
      description = "Environment file as defined in {manpage}`systemd.exec(5)`.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "bouncarr";
      description = "User account under which Bouncarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "bouncarr";
      description = "Group under which Bouncarr runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "bouncarr") {
      bouncarr = {
        isSystemUser = true;
        group = cfg.group;
        home = stateDir;
        description = "Bouncarr service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "bouncarr") {
      bouncarr = { };
    };

    systemd.services.bouncarr = {
      description = "Authentication proxy for the *arr stack using Jellyfin SSO";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = secretsReplacement.script;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "bouncarr";
        StateDirectoryMode = "0700";
        WorkingDirectory = stateDir;
        ExecStart = lib.getExe cfg.package;
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
