{ config, lib, options, pkgs, ... }:

let
  cfg = config.services.ergo;
  opt = options.services.ergo;

  inherit (lib) literalExpression mkEnableOption mkIf mkOption optionalString types;

  configFile = pkgs.writeText "ergo.conf" (''
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
'' + optionalString (cfg.api.keyHash != null) ''
 restApi {
    apiKeyHash = "${cfg.api.keyHash}"
    bindAddress = "${cfg.api.listen.ip}:${toString cfg.api.listen.port}"
 }
'' + ''
}
'');

in {

  options = {

    services.ergo = {
      enable = mkEnableOption "Ergo service";

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/ergo";
        description = "The data directory for the Ergo node.";
      };

      listen = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "IP address on which the Ergo node should listen.";
        };

        port = mkOption {
          type = types.port;
          default = 9006;
          description = "Listen port for the Ergo node.";
        };
      };

      api = {
       keyHash = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "324dcf027dd4a30a932c441f365a25e86b173defa4b8e58948253471b81b72cf";
        description = "Hex-encoded Blake2b256 hash of an API key as a 64-chars long Base16 string.";
       };

       listen = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "IP address that the Ergo node API should listen on if {option}`api.keyHash` is defined.";
          };

        port = mkOption {
          type = types.port;
          default = 9052;
          description = "Listen port for the API endpoint if {option}`api.keyHash` is defined.";
        };
       };
      };

      testnet = mkOption {
         type = types.bool;
         default = false;
         description = "Connect to testnet network instead of the default mainnet.";
      };

      user = mkOption {
        type = types.str;
        default = "ergo";
        description = "The user as which to run the Ergo node.";
      };

      group = mkOption {
        type = types.str;
        default = cfg.user;
        defaultText = literalExpression "config.${opt.user}";
        description = "The group as which to run the Ergo node.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Ergo node as well as the API.";
      };
    };
  };

  config = mkIf cfg.enable {

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
        ExecStart = ''${pkgs.ergo}/bin/ergo \
                      ${optionalString (!cfg.testnet)
                      "--mainnet"} \
                      -c ${configFile}'';
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ] ++ [ cfg.api.listen.port ];
    };

    users.users.${cfg.user} = {
      name = cfg.user;
      group = cfg.group;
      description = "Ergo daemon user";
      home = cfg.dataDir;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = {};

  };
}
