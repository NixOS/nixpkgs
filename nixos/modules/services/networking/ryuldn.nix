{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ryuldn;
  user = "ryuldn";
  dataDir = "/var/lib/${user}";
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.settings.port ];

    services.redis.servers.ryuldn = {
      enable = cfg.redis.enable;
      port = 0;
      save = [ ];
      settings.loadmodule = [ "${pkgs.redisjson}/lib/librejson.so" ];
      inherit user;
    };

    systemd.services = {
      ryuldn = {
        after = [ "network.target" ];
        environment =
          lib.concatMapAttrs (n: v: {
            ${"LDN_" + lib.toUpper n} = if lib.isBool v then lib.boolToString v else toString v;
          }) cfg.settings
          // {
            LDN_REDIS_SOCKET = lib.optionalString cfg.redis.enable config.services.redis.servers.ryuldn.unixSocket;
          };
        script = lib.getExe cfg.package;
        serviceConfig = {
          User = user;
          WorkingDirectory = dataDir;
        };
        wantedBy = [ "multi-user.target" ];
      };
      ryuldn-web = {
        enable = cfg.web.enable;
        after = [
          "network.target"
          "ryuldn.service"
        ];
        environment =
          lib.concatMapAttrs (n: v: {
            ${lib.toUpper n} = if lib.isBool v then lib.boolToString v else toString v;
          }) cfg.web.settings
          // {
            DATA_PATH = dataDir;
            REDIS_SOCKET = lib.optionalString cfg.redis.enable config.services.redis.servers.ryuldn.unixSocket;
          };
        script = lib.getExe cfg.web.package;
        serviceConfig = {
          User = user;
          WorkingDirectory = dataDir;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

    users = {
      groups.${user} = { };
      users.${user} = {
        createHome = true;
        group = user;
        home = dataDir;
        isSystemUser = true;
      };
    };
  };

  options.services.ryuldn = {
    enable = lib.mkEnableOption "RyuLDN Multiplayer Server";
    package = lib.mkPackageOption pkgs "ryuldn" { };
    redis.enable = lib.mkEnableOption "Analytics via Redis" // {
      default = true;
    };
    settings = lib.mkOption {
      description = "Configuration options for the RyuLDN Multiplayer Server";
      type = lib.types.submodule {
        options = {
          gamelist_path = lib.mkOption {
            default = "${cfg.package}/gamelist.json";
            defaultText = lib.literalExpression "\${config.services.ryuldn.package}/gamelist.json";
            description = "The path to the file containing a mapping of application ids and names";
            type = lib.types.path;
          };
          host = lib.mkOption {
            default = "0.0.0.0";
            description = "The address the server should be listening on";
            type = lib.types.str;
          };
          port = lib.mkOption {
            default = 30456;
            description = "The port the server should be using";
            type = lib.types.int;
          };
        };
      };
    };
    web = lib.mkOption {
      description = "RyuLDN Website for the RyuLDN Multiplayer Server";
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "RyuLDN Website";
          package = lib.mkPackageOption pkgs "ryuldn-web" { };
          settings = lib.mkOption {
            description = "Configuration options for the RyuLDN Website";
            type = lib.types.submodule {
              options = {
                node_env = lib.mkOption {
                  default = "production";
                  description = "This should be set to production or development depending on the current environment";
                  example = "development";
                  type = lib.types.str;
                };
                host = lib.mkOption {
                  default = "127.0.0.1";
                  description = "The address this server should be listening on";
                  type = lib.types.str;
                };
                port = lib.mkOption {
                  default = 3000;
                  description = "The port this server should be using";
                  type = lib.types.int;
                };
              };
            };
          };
        };
      };
    };
  };

  meta.maintainers = [ lib.maintainers.SchweGELBin ];
}
