{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.clightning;

  mkLightningNode = cfg: network:
    let
      configFile = pkgs.writeText "clightning-${network}.conf" cfg.config;
    in
    {
      description = "clightning ${network} node";

      # clightning requires bitcoin-cli to talk to either spruned or bitcoind
      path = [ pkgs.altcoins.bitcoind ];

      after = [ "network.target" ];
      wantedBy = optional cfg.autoStart "multi-user.target";

      serviceConfig.ExecStart = "${pkgs.clightning}/bin/lightningd --lightning-dir=${cfg.dataDir} --conf=${configFile}";
      serviceConfig.Restart = "on-abort";
    };
in
{
  options = {
    services.clightning = {
      networks = mkOption {
        default = {};

        description = ''
          Each attribute of this option defines a systemd user service that runs a
          clightning node. The name of each systemd service is
          <literal>clightning-<replaceable>network</replaceable>.service</literal>,
          where <replaceable>network</replaceable> is the corresponding attribute
          name.
        '';

        example = ''
          {
            mainnet = {
              dataDir = "/home/user/.lightning-bitcoin";
              config = '''
                fee-per-satoshi=9000
                lightning-dir=/home/user/.lightning-bitcoin
                network=bitcoin
                log-level=info
                alias=mynode
                rgb=ff0000
              ''';
            };

            testnet = {
              dataDir = "/home/user/.lightning-testnet";
              config = '''
                fee-per-satoshi=1000
                network=testnet
                log-level=debug
                alias=my-testnet-node
                rgb=00ff00
              ''';
            };
          }
        '';



        type = types.attrsOf (types.submodule {
          options = {

            dataDir = mkOption {
              type = types.path;
              description = ''
                clightning data directory
              '';
            };

            config = mkOption {
              type = types.lines;
              description = ''
                Configuration of this clightning node.
              '';
            };

            autoStart = mkOption {
              default = true;
              type = types.bool;
              description = "Whether this clightning instance should be started automatically.";
            };
          };
        });

      };

    };

  };

  config = mkIf (cfg.networks != {}) {

    systemd.user.services =
      listToAttrs (mapAttrsFlatten (name: value: nameValuePair "clightning-${name}" (mkLightningNode value name)) cfg.networks);

    environment.systemPackages = [ pkgs.clightning ];

  };

}
