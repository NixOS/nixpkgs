{ config, lib, pkgs, ... }:

let
  cfg = config.services.gotosocial;
  settingsFormat = pkgs.formats.yaml {};
  doMkUser = (cfg.user == "gotosocial") && (cfg.group == "gotosocial");

  defaultSettings = {
    application-name = "gotosocial";
    host = "localhost";
    #bind-address = "[::]";
    bind-address = "127.0.0.1";
    port = 8080;
    storage-local-base-path = "/var/lib/gotosocial/storage";
    db-type = "postgres";
    db-address = "/run/postgresq"; # TODO: socket?
    db-port = 5432;
    db-database = "gotosocial";
    db-user = "gotosocial";
    db-password = "";
    db-tls-mode = "disable";
  };
  setting = defaultSettings // cfg.settings;

in {
  options.services.gotosocial = {
      enable = lib.mkEnableOption (lib.mdDoc "GotoSocial, a ActivityPub server");

      package = lib.mkPackageOption pkgs "gotosocial" {};

      extraGroups = lib.mkOption {
        description = lib.mdDoc "GotoSocials auxiliary groups.";
        type = with lib.types; listOf str;
        default = [ ];
        example = [ "todo" ];
      };

      extraArgs = lib.mkOption {
        description = lib.mdDoc ''
          Extra command line arguments to pass to the GotoSocial daemon.
          Refer to `gotosocial --help`.
        '';
        type = with lib.types; listOf str;
        default = [ ];
        example = [ "--media-image-max-size" "2097152" ];
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Open the configured port in the firewall.
          We highly reccommend using a reverse proxy instead.
        '';
      };

      setupDB = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to setup a local postgres database and populate the
          `db-type` fields in `services.gotosocial.settings`.
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        description = lib.mdDoc ''
          Contents of the GotoSocial YAML config.
          Please refer to the
          [documentation](https://docs.gotosocial.org/en/latest/configuration/)
          and
          [example config](https://github.com/superseriousbusiness/gotosocial/blob/main/example/config.yaml).
          _Note_: the `example` keys are set by default, and
          the `db-type` fields are set automatically if `services.gotosocial.setupDB` is true.
        '';
        default = {};
        example = lib.filterAttrs (key: val: (builtins.substring 0 7 val) != "db-type"  ) defaultSettings;
      };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.gotosocial = {
      description = "GotoSocial Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]
        ++ lib.optional cfg.setupDB "postgresql.service";
      requires = lib.mkIf cfg.setupDB [ "postgresql.service" ];

      script = lib.escapeShellArgs ([
        "${cfg.package}/bin/gotosocial"
        "--config-path"
          (settingsFormat.generate "gotosocial-config.yaml" setting)
        "server"
        "start"
      ] ++ cfg.extraArgs);

      serviceConfig = rec {
        User = "gotosocial";
        Group = "gotosocial";
        DynamicUser = true;
        SupplementaryGroups = cfg.extraGroups;
        StateDirectory = "gotosocial";
        #WorkingDirectory = # TODO
        Restart = "on-failure";

        # Security options:
        # Based on https://github.com/superseriousbusiness/gotosocial/blob/4cd00d546c495b085487d11f2fe2c4928600dc10/example/gotosocial.service

        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        DevicePolicy = "closed";
        ProtectSystem = "full";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        LockPersonality = true;
        SystemCallFilter = [ "@clock" "@debug" "@module" "@mount" "@obsolete" "@reboot" "@setuid" "@swa" ];

        CapabilityBoundingSet = [
          "CAP_RAWIO" "CAP_MKNOD"
          "CAP_AUDIT_CONTROL" "CAP_AUDIT_READ" "CAP_AUDIT_WRITE"
          "CAP_SYS_BOOT" "CAP_SYS_TIME" "CAP_SYS_MODULE" "CAP_SYS_PACCT"
          "CAP_LEASE" "CAP_LINUX_IMMUTABLE" "CAP_IPC_LOCK"
          "CAP_BLOCK_SUSPEND" "CAP_WAKE_ALARM"
          "CAP_SYS_TTY_CONFIG"
          "CAP_MAC_ADMIN" "CAP_MAC_OVERRIDE"
          "CAP_NET_ADMIN" "CAP_NET_BROADCAST" "CAP_NET_RAW"
          "CAP_SYS_ADMIN" "CAP_SYS_PTRACE" "CAP_SYSLOG"
        ];

        # We might need this if running as non-root on a privileged port (below 1024)
        #AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };

    services.postgresql = lib.mkIf cfg.setupDB {
      enable = true;
      ensureDatabases = [ "gotosocial" ];
      ensureUsers = [
        {
          name = "gotosocial";
          ensurePermissions."DATABASE gotosocial" = "ALL PRIVILEGES";
        }
      ];
      #authentication = ''
      #  local gotosocial gotosocial peer map=gotosocial
      #'';
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ setting.port ];
    };

  };
}
