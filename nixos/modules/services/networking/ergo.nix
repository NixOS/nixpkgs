{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.ergo;
  opt = options.services.ergo;

  configFile = pkgs.writeText "ergo.conf" (
    ''
      ergo {
        directory = "${cfg.dataDir}"
        node {
          mining = false
        }
        wallet.secretStorage.secretDir = "${cfg.dataDir}/wallet/keystore"
      }

      scorex {
        network {
          bindAddress = "${cfg.listen.ip}:${toString cfg.listen.port}"
        }
    ''
    + lib.optionalString (cfg.api.keyHash != null) ''
      restApi {
         apiKeyHash = "${cfg.api.keyHash}"
         bindAddress = "${cfg.api.listen.ip}:${toString cfg.api.listen.port}"
      }
    ''
    + ''
      }
    ''
  );

in
{

  options = {

    services.ergo = {
      enable = lib.mkEnableOption "Ergo service";

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/ergo";
        description = "The data directory for the Ergo node.";
      };

      listen = {
        ip = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "IP address on which the Ergo node should listen.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 9006;
          description = "Listen port for the Ergo node.";
        };
      };

      api = {
        keyHash = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "324dcf027dd4a30a932c441f365a25e86b173defa4b8e58948253471b81b72cf";
          description = "Hex-encoded Blake2b256 hash of an API key as a 64-chars long Base16 string.";
        };

        listen = {
          ip = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = "IP address that the Ergo node API should listen on if {option}`api.keyHash` is defined.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 9052;
            description = "Listen port for the API endpoint if {option}`api.keyHash` is defined.";
          };
        };
      };

      testnet = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Connect to testnet network instead of the default mainnet.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ergo";
        description = "The user as which to run the Ergo node.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = cfg.user;
        defaultText = lib.literalExpression "config.${opt.user}";
        description = "The group as which to run the Ergo node.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Ergo node as well as the API.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 '${cfg.user}' '${cfg.group}' - -"
    ];

    systemd.services.ergo = {
      description = "ergo server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.ergo}/bin/ergo \
                                ${lib.optionalString (!cfg.testnet) "--mainnet"} \
                                -c ${configFile}'';
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ] ++ [ cfg.api.listen.port ];
    };

    users.users.${cfg.user} = {
      name = cfg.user;
      group = cfg.group;
      description = "Ergo daemon user";
      home = cfg.dataDir;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

  };
}
