{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.bitmagnet;
  inherit (lib)
    mkEnableOption
    mkIf
    lib.mkOption
    mkPackageOption
    lib.optional
    ;
  inherit (lib.types)
    bool
    int
    port
    str
    submodule
    ;
  inherit (lib.generators) toYAML;

  freeformType = (pkgs.formats.yaml { }).type;
in
{
  options.services.bitmagnet = {
    enable = lib.mkEnableOption "Bitmagnet service";
    useLocalPostgresDB = lib.mkOption {
      description = "Use a local postgresql database, create user and database";
      type = bool;
      default = true;
    };
    settings = lib.mkOption {
      description = "Bitmagnet configuration (https://bitmagnet.io/setup/configuration.html).";
      default = { };
      type = submodule {
        inherit freeformType;
        options = {
          http_server = lib.mkOption {
            default = { };
            description = "HTTP server settings";
            type = submodule {
              inherit freeformType;
              options = {
                port = lib.mkOption {
                  type = str;
                  default = ":3333";
                  description = "HTTP server listen port";
                };
              };
            };
          };
          dht_server = lib.mkOption {
            default = { };
            description = "DHT server settings";
            type = submodule {
              inherit freeformType;
              options = {
                port = lib.mkOption {
                  type = port;
                  default = 3334;
                  description = "DHT listen port";
                };
              };
            };
          };
          postgres = lib.mkOption {
            default = { };
            description = "PostgreSQL database configuration";
            type = submodule {
              inherit freeformType;
              options = {
                host = lib.mkOption {
                  type = str;
                  default = "";
                  description = "Address, hostname or Unix socket path of the database server";
                };
                name = lib.mkOption {
                  type = str;
                  default = "bitmagnet";
                  description = "Database name to connect to";
                };
                user = lib.mkOption {
                  type = str;
                  default = "";
                  description = "User to connect as";
                };
                password = lib.mkOption {
                  type = str;
                  default = "";
                  description = "Password for database user";
                };
              };
            };
          };
        };
      };
    };
    package = lib.mkPackageOption pkgs "bitmagnet" { };
    user = lib.mkOption {
      description = "User running bitmagnet";
      type = str;
      default = "bitmagnet";
    };
    group = lib.mkOption {
      description = "Group of user running bitmagnet";
      type = str;
      default = "bitmagnet";
    };
    openFirewall = lib.mkOption {
      description = "Open DHT ports in firewall";
      type = bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc."xdg/bitmagnet/config.yml" = {
      text = toYAML { } cfg.settings;
      mode = "0440";
      user = cfg.user;
      group = cfg.group;
    };
    systemd.services.bitmagnet = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ] ++ lib.optional cfg.useLocalPostgresDB "postgresql.service";
      requires = lib.optional cfg.useLocalPostgresDB "postgresql.service";
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/bitmagnet worker run --all";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/bitmagnet";
        StateDirectory = "bitmagnet";

        # Sandboxing (sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };
    users.users = lib.mkIf (cfg.user == "bitmagnet") {
      bitmagnet = {
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = lib.mkIf (cfg.group == "bitmagnet") { bitmagnet = { }; };
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.dht_server.port ];
      allowedUDPPorts = [ cfg.settings.dht_server.port ];
    };
    services.postgresql = lib.mkIf cfg.useLocalPostgresDB {
      enable = true;
      ensureDatabases = [
        cfg.settings.postgres.name
        (if (cfg.settings.postgres.user == "") then cfg.user else cfg.settings.postgres.user)
      ];
      ensureUsers = [
        {
          name = if (cfg.settings.postgres.user == "") then cfg.user else cfg.settings.postgres.user;
          ensureDBOwnership = true;
        }
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ gileri ];
}
