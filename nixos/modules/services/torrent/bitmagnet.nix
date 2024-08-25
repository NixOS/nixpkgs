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
    mkOption
    mkPackageOption
    optional
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
    enable = mkEnableOption "Bitmagnet service";
    useLocalPostgresDB = mkOption {
      description = "Use a local postgresql database, create user and database";
      type = bool;
      default = true;
    };
    settings = mkOption {
      description = "Bitmagnet configuration (https://bitmagnet.io/setup/configuration.html).";
      default = { };
      type = submodule {
        inherit freeformType;
        options = {
          http_server = mkOption {
            default = { };
            type = submodule {
              inherit freeformType;
              options = {
                port = mkOption {
                  type = str;
                  default = ":3333";
                };
              };
            };
          };
          dht_server = mkOption {
            default = { };
            type = submodule {
              inherit freeformType;
              options = {
                port = mkOption {
                  type = port;
                  default = 3334;
                };
              };
            };
          };
          postgres = mkOption {
            default = { };
            type = submodule {
              inherit freeformType;
              options = {
                host = mkOption {
                  type = str;
                  default = "";
                };
                name = mkOption {
                  type = str;
                  default = "bitmagnet";
                };
                user = mkOption {
                  type = str;
                  default = "";
                };
                password = mkOption {
                  type = str;
                  default = "";
                };
              };
            };
          };
        };
      };
    };
    package = mkPackageOption pkgs "bitmagnet" { };
    user = mkOption {
      description = "User running bitmagnet";
      type = str;
      default = "bitmagnet";
    };
    group = mkOption {
      description = "Group of user running bitmagnet";
      type = str;
      default = "bitmagnet";
    };
    openFirewall = mkOption {
      description = "Open DHT ports in firewall";
      type = bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
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
      ] ++ optional cfg.useLocalPostgresDB "postgresql.service";
      requires = optional cfg.useLocalPostgresDB "postgresql.service";
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
    users.users = mkIf (cfg.user == "bitmagnet") {
      bitmagnet = {
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "bitmagnet") { bitmagnet = { }; };
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.dht_server.port ];
      allowedUDPPorts = [ cfg.dht_server.port ];
    };
    services.postgresql = mkIf cfg.useLocalPostgresDB {
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
