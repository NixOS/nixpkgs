{ config, pkgs, ... }:

with pkgs.lib;

let

  gcfg = config.services.bitcoin;

  makeBitcoinWallet = cfg: name:
    let
      dataDir = "${gcfg.dataDir}/${name}";

      configFile = pkgs.writeText "${name}.conf"
        ''
          datadir=${dataDir}
          ${cfg.config}
        '';

    in {
      description = "Bitcoin Wallet Instance For ‘${name}’";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];

      preStart = ''
        mkdir -m 0700 -p ${dataDir}
        if [ "$(id -u)" = 0 ]; then
          chown -R ${gcfg.user} ${dataDir}
        fi
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${cfg.package.walletName}d -conf=${configFile}";
        PermissionsStartOnly = true;
        User = gcfg.user;
      };
    };

in {

  ###### interface

  options = {

    services.bitcoin = {

      user = mkOption {
        default = "bitcoin";
        description = "User account under which bitcoin related services run";
        type = types.str;
      };

      dataDir = mkOption {
        default = "/var/lib/wallets";
        description = "Base data directory for wallets";
        type = types.path;
      };

      wallets = mkOption {
        default = {};

        example = literalExample ''
          {
            bitcoin = {
              config = '''
                rpcuser=test
                rpcpassword=dasdGfhoiu35BCV47586fgdh234GDFSEG
                rpcport=7333
              ''';
              package = pkgs.bitcoinWallets.bitcoin;
            };
            litecoin = {
              config = '''
                rpcuser=liteuserx
                rpcpassword=nkrt345udsdfjhgjhsdfuyrt78rtTJHRFHTDTYD
                rpcport=9334
                port=9335
                gen=0
              ''';
              package = pkgs.bitcoinWallets.litecoin;
            };
          }
        '';

        description = ''
          Each attribute of this option defines a systemd service that
          runs a bitcoin wallet instance. The name of each systemd service is
          <literal>bitcoin-<replaceable>name</replaceable>.service</literal>,
          where <replaceable>name</replaceable> is the corresponding
          attribute name.
        '';

        type = types.attrsOf types.optionSet;

        options = {
          config = mkOption {
            description = "Configuration of bitcoin wallet instance.";
            default = ''
              rpcuser=bitcoin
              rpcpassword=test
            '';
            type = types.lines;
          };

          package = mkOption {
            description = "Which bitcoin wallet package to use";
            default = pkgs.bitcoind;
            type = types.package;
          };
        };
      };

    };

  };


  ###### implementation

  config = mkIf (gcfg.wallets != {}) {

    users.extraUsers = optionalAttrs (gcfg.user == "bitcoin") (singleton
      { name = "bitcoin";
        uid = config.ids.uids.bitcoin;
        description = "Bitcoin user";
        home = gcfg.dataDir;
      });

    systemd.services = listToAttrs (mapAttrsFlatten (name: value: nameValuePair "${name}" (makeBitcoinWallet value name)) gcfg.wallets);

  };

}
