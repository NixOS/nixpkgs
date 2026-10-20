{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.semaphoreui;

  settingsFormat = pkgs.formats.json { };

  configFile = settingsFormat.generate "semaphore.json" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ vysakh ];

  options.services.semaphoreui = {
    enable = lib.mkEnableOption "Semaphore UI";

    package = lib.mkPackageOption pkgs "semaphoreui" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "semaphore";
      description = "User account under which Semaphore UI runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "semaphore";
      description = "Group account under which Semaphore UI runs.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/semaphore";
      description = "Directory to store Semaphore UI state.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "trace"
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = "Log level of the Semaphore UI server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port on which Semaphore UI listens.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        Configuration of Semaphore UI. See <https://docs.semaphoreui.com/administration-guide/configuration>
        for the available settings.

        Secrets such as `cookie_hash`, `cookie_encryption` and
        `access_key_encryption` can be passed through {option}`services.semaphoreui.environmentFile`
        instead of storing them in the Nix store.
      '';
      example = lib.literalExpression ''
        {
          dialect = "postgres";
          postgres = {
            host = "localhost:5432";
            user = "semaphore";
            name = "semaphore";
          };
          web_host = "https://semaphore.example.com";
        }
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/semaphore";
      description = ''
        Path to a file containing extra Semaphore UI environment variables in the
        systemd `EnvironmentFile` format. This can be used to pass secrets without
        putting them in the Nix store.

        Semaphore UI accepts environment variables such as `SEMAPHORE_COOKIE_HASH`,
        `SEMAPHORE_COOKIE_ENCRYPTION` and `SEMAPHORE_ACCESS_KEY_ENCRYPTION`.
      '';
    };

    path = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        ansible
        git
        openssh
        python3
      ];
      defaultText = lib.literalExpression "with pkgs; [ ansible git openssh python3 ]";
      description = "Packages added to the service's `PATH`.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for Semaphore UI.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environmentFile != null || (cfg.settings.cookie_hash or "") != "";
        message = "services.semaphoreui.settings.cookie_hash must be set to a base64-encoded 32-byte value or provided via services.semaphoreui.environmentFile";
      }
      {
        assertion = cfg.environmentFile != null || (cfg.settings.cookie_encryption or "") != "";
        message = "services.semaphoreui.settings.cookie_encryption must be set to a base64-encoded 32-byte value or provided via services.semaphoreui.environmentFile";
      }
      {
        assertion = (cfg.settings.port or ":${toString cfg.port}") == ":${toString cfg.port}";
        message = "services.semaphoreui.port and services.semaphoreui.settings.port must match; use services.semaphoreui.port to configure the listening port";
      }
    ];

    services.semaphoreui.settings = {
      dialect = lib.mkDefault "sqlite";
      sqlite.host = lib.mkDefault "${cfg.stateDir}/semaphore.sqlite";
      tmp_path = lib.mkDefault "/run/semaphore/tmp";
      port = lib.mkDefault ":${toString cfg.port}";
      web_host = lib.mkDefault "http://localhost:${toString cfg.port}";
      dirs = {
        secrets = lib.mkDefault "/run/semaphore/secrets";
        repos = lib.mkDefault "${cfg.stateDir}/repos";
        ssh_agent_sockets = lib.mkDefault "/run/semaphore/ssh-agent-sockets";
      };
    };

    users.users = lib.mkIf (cfg.user == "semaphore") {
      semaphore = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.stateDir;
        createHome = true;
        description = "Semaphore UI service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "semaphore") {
      semaphore = { };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.stateDir}/repos 0750 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.semaphoreui = {
      description = "Semaphore UI";
      documentation = [ "https://docs.semaphoreui.com/" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "systemd-tmpfiles-setup.service"
      ];

      inherit (cfg) path;

      environment.HOME = cfg.stateDir;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;

        ExecStart = "${lib.getExe cfg.package} server --config ${configFile} --log-level ${cfg.logLevel}";
        ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = 10;

        RuntimeDirectory = [
          "semaphore"
          "semaphore/secrets"
          "semaphore/ssh-agent-sockets"
          "semaphore/tmp"
        ];
        RuntimeDirectoryMode = "0700";

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        ReadWritePaths = [ cfg.stateDir ];

        UMask = "0077";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        LockPersonality = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        CapabilityBoundingSet = "";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
