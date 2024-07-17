{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.woodpecker-server;
in
{
  meta.maintainers = with lib.maintainers; [
    janik
    ambroisie
  ];

  options = {
    services.woodpecker-server = {
      enable = lib.mkEnableOption "the Woodpecker-Server, a CI/CD application for automatic builds, deployments and tests";
      package = lib.mkPackageOption pkgs "woodpecker-server" { };
      environment = lib.mkOption {
        default = { };
        type = lib.types.attrsOf lib.types.str;
        example = lib.literalExpression ''
          {
            WOODPECKER_HOST = "https://woodpecker.example.com";
            WOODPECKER_OPEN = "true";
            WOODPECKER_GITEA = "true";
            WOODPECKER_GITEA_CLIENT = "ffffffff-ffff-ffff-ffff-ffffffffffff";
            WOODPECKER_GITEA_URL = "https://git.example.com";
          }
        '';
        description = "woodpecker-server config environment variables, for other options read the [documentation](https://woodpecker-ci.org/docs/administration/server-config)";
      };
      environmentFile = lib.mkOption {
        type = with lib.types; coercedTo path (f: [ f ]) (listOf path);
        default = [ ];
        example = [ "/root/woodpecker-server.env" ];
        description = ''
          File to load environment variables
          from. This is helpful for specifying secrets.
          Example content of environmentFile:
          ```
          WOODPECKER_AGENT_SECRET=your-shared-secret-goes-here
          WOODPECKER_GITEA_SECRET=gto_**************************************
          ```
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      woodpecker-server = {
        description = "Woodpecker-Server Service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          DynamicUser = true;
          WorkingDirectory = "%S/woodpecker-server";
          StateDirectory = "woodpecker-server";
          StateDirectoryMode = "0700";
          UMask = "0007";
          ConfigurationDirectory = "woodpecker-server";
          EnvironmentFile = cfg.environmentFile;
          ExecStart = "${cfg.package}/bin/woodpecker-server";
          Restart = "on-failure";
          RestartSec = 15;
          CapabilityBoundingSet = "";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
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
          RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
        };
        inherit (cfg) environment;
      };
    };
  };
}
