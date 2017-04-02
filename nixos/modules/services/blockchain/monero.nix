{ config, options, pkgs, lib, ... }:

with lib;

let

  description = "Monero Full Node";
  walletDescription = "Monero Wallet RPC Daemon";

  cu = pkgs.coreutils;

  cfg = config.services.monerod;
  opts = options.services.monerod;

  configFile = optionalString (!isNull cfg.extraConfig) (" --config-file=${pkgs.writeText "monerod.conf" cfg.extraConfig}");

  makeWalletJob = name: conf:
  let

    options = [
      "--wallet-file=${conf.walletDir}/${conf.walletFile}"
      (optionalString (!isNull conf.walletPassword) "--password=${conf.walletPassword}")
      (optionalString (!isNull conf.walletPasswordFile) "--password-file=${conf.walletPasswordFile}")
      (optionalString (!isNull conf.bindAddress) "--rpc-bind-ip=${conf.bindAddress}")
      (optionalString (conf.confirmExternalBind) "--confirm-external-bind")
      (optionalString (!isNull conf.bindPort) "--rpc-bind-port=${toString conf.bindPort}")
      (optionalString (!isNull conf.login) "--rpc-login=${conf.login}")
      ] ++ conf.extraOptions;

  in

  {

    inherit (conf) enable;

    description = "${walletDescription}: ${name}";
    after = [ "network.target" ];
    wantedBy = [ (if conf.independent then "multi-user.target" else "monerod.service") ];
    bindsTo = [ (optionalString (!conf.independent) "monerod.service") ];

    serviceConfig = {
      User = cfg.user;
      Group = cfg.group;
      WorkingDirectory = cfg.dataDir;

      ExecStartPre = [
        "+${cu}/bin/chown -R ${cfg.user}:${cfg.group} ${conf.walletDir}"
        "+${cu}/bin/chmod -R 700 ${conf.walletDir}"
      ];
      ExecStart = "${cfg.package}/bin/monero-wallet-rpc ${toString options}";

      Restart = "always";
      PrivateTmp = true;
      TimeoutStopSec = 60;
    };

  };

in

{

  options = {

    services.monerod = {

      enable = mkOption {
        default = false;
        description = "Enable ${description}";
        type = types.bool;
      };

      package = mkOption {
        default = pkgs.monero;
        description = "Package to use";
        type = types.package;
      };

      user = mkOption {
         default = "monero";
         description = "Monero daemon user"; 
         type = types.str;
      };

      group = mkOption {
         default = "monero";
         description = "Monero daemon group";
         type = types.str;
      };

      dataDir = mkOption {
        description = "Data directory";
        type = types.path;
      };

      extraConfig = mkOption {
        description = "Additional configuration";
        type = types.nullOr types.str;
      };

      wallets = mkOption {
        default = {};
        description = "Additional wallet RPC daemons to start";
        type = with types; attrsOf (submodule {

          options = {

            enable = mkOption {
              default = true;
              description = "Enable ${walletDescription}";
              type = types.bool;
            };

            independent = mkOption {
              default = false;
              description = "Wallet daemon is independent from monerod";
              type = types.bool;
            };

            walletDir = mkOption {
              description = "Directory of wallet files";
              type = types.path;
            };

            walletFile = mkOption {
              default = "wallet.bin";
              description = "Wallet file name";
              type = types.str;
            };

            walletPassword = mkOption {
              default = null;
              description = "Wallet password";
              type = types.nullOr types.str;
            };

            walletPasswordFile = mkOption {
              default = null;
              description = "Wallet password file";
              type = types.nullOr types.path;
            };

            bindAddress = mkOption {
              default = null;
              description = "Specify ip to bind RPC server";
              type = types.nullOr types.str;
            };

            bindPort = mkOption {
              default = null;
              description = "Sets bind port for RPC server";
              type = types.nullOr types.int;
            };

            confirmExternalBind = mkOption {
              default = false;
              description = "Confirm bindAddress value is NOT a loopback (local) IP";
              type = types.bool;
            };

            login = mkOption {
              default = null;
              description = "Specify username[:password] required for RPC server";
              type = types.nullOr types.str;
            };

            extraOptions = mkOption {
              default = [];
              description = "Additional command-line options";
              type = types.listOf types.str;
            };

          };

        });


      };

    };

  };

  config = mkIf cfg.enable (mkMerge [{

    systemd.services.monerod = {

      inherit description;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;

        Type = "forking";
        GuessMainPID = "no";

        ExecStart = "${cfg.package}/bin/monerod --detach${configFile} --data-dir=${cfg.dataDir}";

        Restart = "always";
        PrivateTmp = true;
        TimeoutStopSec = 60;
      };
    };

    users = {
      extraUsers = optionalAttrs (cfg.user == opts.user.default) (singleton {
        name = opts.user.default;
        uid = config.ids.uids.${opts.user.default};
        group = opts.group.default;
        description = opts.user.defaultText;
        home = cfg.dataDir;
        createHome = true;
      });

      extraGroups = optionalAttrs (cfg.group == opts.group.default) (singleton {
        name = opts.group.default;
        gid = config.ids.gids.${opts.group.default};
      });
    };


    environment.systemPackages = [ cfg.package ];
 

  } (mkIf (cfg.wallets != {}) {

    systemd.services = mapAttrs' (name: value: nameValuePair "monero-wallet-${name}" (makeWalletJob name value)) cfg.wallets;

  })]);

}
