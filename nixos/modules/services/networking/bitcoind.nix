{
  config,
  pkgs,
  lib,
  ...
}:

let
  eachBitcoind = lib.filterAttrs (bitcoindName: cfg: cfg.enable) config.services.bitcoind;

  rpcUserOpts =
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "alice";
          description = ''
            Username for JSON-RPC connections.
          '';
        };
        passwordHMAC = lib.mkOption {
          type = lib.types.uniq (lib.types.strMatching "[0-9a-f]+\\$[0-9a-f]{64}");
          example = "f7efda5c189b999524f151318c0c86$d5b51b3beffbc02b724e5d095828e0bc8b2456e9ac8757ae3211a5d9b16a22ae";
          description = ''
            Password HMAC-SHA-256 for JSON-RPC connections. Must be a string of the
            format \<SALT-HEX\>$\<HMAC-HEX\>.

            Tool (Python script) for HMAC generation is available here:
            <https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py>
          '';
        };
      };
      config = {
        name = lib.mkDefault name;
      };
    };

  bitcoindOpts =
    {
      config,
      lib,
      name,
      ...
    }:
    {
      options = {

        enable = lib.mkEnableOption "Bitcoin daemon";

        package = lib.mkPackageOption pkgs "bitcoind" { };

        configFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/${name}/bitcoin.conf";
          description = "The configuration file path to supply bitcoind.";
        };

        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          example = ''
            par=16
            rpcthreads=16
            logips=1
          '';
          description = "Additional configurations to be appended to {file}`bitcoin.conf`.";
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/bitcoind-${name}";
          description = "The data directory for bitcoind.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "bitcoind-${name}";
          description = "The user as which to run bitcoind.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = config.user;
          description = "The group as which to run bitcoind.";
        };

        rpc = {
          port = lib.mkOption {
            type = lib.types.nullOr lib.types.port;
            default = null;
            description = "Override the default port on which to listen for JSON-RPC connections.";
          };
          users = lib.mkOption {
            default = { };
            example = lib.literalExpression ''
              {
                alice.passwordHMAC = "f7efda5c189b999524f151318c0c86$d5b51b3beffbc02b724e5d095828e0bc8b2456e9ac8757ae3211a5d9b16a22ae";
                bob.passwordHMAC = "b2dd077cb54591a2f3139e69a897ac$4e71f08d48b4347cf8eff3815c0e25ae2e9a4340474079f55705f40574f4ec99";
              }
            '';
            type = lib.types.attrsOf (lib.types.submodule rpcUserOpts);
            description = "RPC user information for JSON-RPC connections.";
          };
        };

        pidFile = lib.mkOption {
          type = lib.types.path;
          default = "${config.dataDir}/bitcoind.pid";
          description = "Location of bitcoind pid file.";
        };

        testnet = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to use the testnet instead of mainnet.";
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          description = "Override the default port on which to listen for connections.";
        };

        dbCache = lib.mkOption {
          type = lib.types.nullOr (lib.types.ints.between 4 16384);
          default = null;
          example = 4000;
          description = "Override the default database cache size in MiB.";
        };

        prune = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.coercedTo (lib.types.enum [
              "disable"
              "manual"
            ]) (x: if x == "disable" then 0 else 1) lib.types.ints.unsigned
          );
          default = null;
          example = 10000;
          description = ''
            Reduce storage requirements by enabling pruning (deleting) of old
            blocks. This allows the pruneblockchain RPC to be called to delete
            specific blocks, and enables automatic pruning of old blocks if a
            target size in MiB is provided. This mode is incompatible with -txindex
            and -rescan. Warning: Reverting this setting requires re-downloading
            the entire blockchain. ("disable" = disable pruning blocks, "manual"
            = allow manual pruning via RPC, >=550 = automatically prune block files
            to stay under the specified target size in MiB).
          '';
        };

        extraCmdlineOptions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Extra command line options to pass to bitcoind.
            Run bitcoind --help to list all available options.
          '';
        };
      };
    };
in
{

  options = {
    services.bitcoind = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule bitcoindOpts);
      default = { };
      description = "Specification of one or more bitcoind instances.";
    };
  };

  config = lib.mkIf (eachBitcoind != { }) {

    assertions = lib.flatten (
      lib.mapAttrsToList (bitcoindName: cfg: [
        {
          assertion =
            (cfg.prune != null)
            -> (
              builtins.elem cfg.prune [
                "disable"
                "manual"
                0
                1
              ]
              || (builtins.isInt cfg.prune && cfg.prune >= 550)
            );
          message = ''
            If set, services.bitcoind.${bitcoindName}.prune has to be "disable", "manual", 0 , 1 or >= 550.
          '';
        }
        {
          assertion = (cfg.rpc.users != { }) -> (cfg.configFile == null);
          message = ''
            You cannot set both services.bitcoind.${bitcoindName}.rpc.users and services.bitcoind.${bitcoindName}.configFile
            as they are exclusive. RPC user setting would have no effect if custom configFile would be used.
          '';
        }
      ]) eachBitcoind
    );

    environment.systemPackages = lib.flatten (
      lib.mapAttrsToList (bitcoindName: cfg: [
        cfg.package
      ]) eachBitcoind
    );

    systemd.services = lib.mapAttrs' (
      bitcoindName: cfg:
      (lib.nameValuePair "bitcoind-${bitcoindName}" (
        let
          configFile = pkgs.writeText "bitcoin.conf" ''
            # If Testnet is enabled, we need to add [test] section
            # otherwise, some options (e.g.: custom RPC port) will not work
            ${lib.optionalString cfg.testnet "[test]"}
            # RPC users
            ${lib.concatMapStringsSep "\n" (rpcUser: "rpcauth=${rpcUser.name}:${rpcUser.passwordHMAC}") (
              lib.attrValues cfg.rpc.users
            )}
            # Extra config options (from bitcoind nixos service)
            ${cfg.extraConfig}
          '';
        in
        {
          description = "Bitcoin daemon";
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            ExecStart = ''
              ${cfg.package}/bin/bitcoind \
              ${if (cfg.configFile != null) then "-conf=${cfg.configFile}" else "-conf=${configFile}"} \
              -datadir=${cfg.dataDir} \
              -pid=${cfg.pidFile} \
              ${lib.optionalString cfg.testnet "-testnet"}\
              ${lib.optionalString (cfg.port != null) "-port=${toString cfg.port}"}\
              ${lib.optionalString (cfg.prune != null) "-prune=${toString cfg.prune}"}\
              ${lib.optionalString (cfg.dbCache != null) "-dbcache=${toString cfg.dbCache}"}\
              ${lib.optionalString (cfg.rpc.port != null) "-rpcport=${toString cfg.rpc.port}"}\
              ${toString cfg.extraCmdlineOptions}
            '';
            Restart = "on-failure";

            # Hardening measures
            PrivateTmp = "true";
            ProtectSystem = "full";
            NoNewPrivileges = "true";
            PrivateDevices = "true";
            MemoryDenyWriteExecute = "true";
          };
        }
      ))
    ) eachBitcoind;

    systemd.tmpfiles.rules = lib.flatten (
      lib.mapAttrsToList (bitcoindName: cfg: [
        "d '${cfg.dataDir}' 0770 '${cfg.user}' '${cfg.group}' - -"
      ]) eachBitcoind
    );

    users.users = lib.mapAttrs' (
      bitcoindName: cfg:
      (lib.nameValuePair "bitcoind-${bitcoindName}" {
        name = cfg.user;
        group = cfg.group;
        description = "Bitcoin daemon user";
        home = cfg.dataDir;
        isSystemUser = true;
      })
    ) eachBitcoind;

    users.groups = lib.mapAttrs' (bitcoindName: cfg: (lib.nameValuePair "${cfg.group}" { })) eachBitcoind;

  };

  meta.maintainers = with lib.maintainers; [ _1000101 ];

}
