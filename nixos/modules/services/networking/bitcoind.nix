{ config, pkgs, lib, ... }:

with lib;

let

  eachBitcoind = config.services.bitcoind;

  rpcUserOpts = { name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        example = "alice";
        description = lib.mdDoc ''
          Username for JSON-RPC connections.
        '';
      };
      passwordHMAC = mkOption {
        type = types.uniq (types.strMatching "[0-9a-f]+\\$[0-9a-f]{64}");
        example = "f7efda5c189b999524f151318c0c86$d5b51b3beffbc02b724e5d095828e0bc8b2456e9ac8757ae3211a5d9b16a22ae";
        description = ''
          Password HMAC-SHA-256 for JSON-RPC connections. Must be a string of the
          format &lt;SALT-HEX&gt;$&lt;HMAC-HEX&gt;.

          Tool (Python script) for HMAC generation is available here:
          <link xlink:href="https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py"/>
        '';
      };
    };
    config = {
      name = mkDefault name;
    };
  };

  bitcoindOpts = { config, lib, name, ...}: {
    options = {

      enable = mkEnableOption "Bitcoin daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.bitcoind;
        defaultText = literalExpression "pkgs.bitcoind";
        description = lib.mdDoc "The package providing bitcoin binaries.";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/${name}/bitcoin.conf";
        description = lib.mdDoc "The configuration file path to supply bitcoind.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          par=16
          rpcthreads=16
          logips=1
        '';
        description = lib.mdDoc "Additional configurations to be appended to {file}`bitcoin.conf`.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/bitcoind-${name}";
        description = lib.mdDoc "The data directory for bitcoind.";
      };

      user = mkOption {
        type = types.str;
        default = "bitcoind-${name}";
        description = lib.mdDoc "The user as which to run bitcoind.";
      };

      group = mkOption {
        type = types.str;
        default = config.user;
        description = lib.mdDoc "The group as which to run bitcoind.";
      };

      rpc = {
        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = lib.mdDoc "Override the default port on which to listen for JSON-RPC connections.";
        };
        users = mkOption {
          default = {};
          example = literalExpression ''
            {
              alice.passwordHMAC = "f7efda5c189b999524f151318c0c86$d5b51b3beffbc02b724e5d095828e0bc8b2456e9ac8757ae3211a5d9b16a22ae";
              bob.passwordHMAC = "b2dd077cb54591a2f3139e69a897ac$4e71f08d48b4347cf8eff3815c0e25ae2e9a4340474079f55705f40574f4ec99";
            }
          '';
          type = types.attrsOf (types.submodule rpcUserOpts);
          description = lib.mdDoc "RPC user information for JSON-RPC connnections.";
        };
      };

      pidFile = mkOption {
        type = types.path;
        default = "${config.dataDir}/bitcoind.pid";
        description = lib.mdDoc "Location of bitcoind pid file.";
      };

      testnet = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to use the testnet instead of mainnet.";
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = lib.mdDoc "Override the default port on which to listen for connections.";
      };

      dbCache = mkOption {
        type = types.nullOr (types.ints.between 4 16384);
        default = null;
        example = 4000;
        description = lib.mdDoc "Override the default database cache size in MiB.";
      };

      prune = mkOption {
        type = types.nullOr (types.coercedTo
          (types.enum [ "disable" "manual" ])
          (x: if x == "disable" then 0 else 1)
          types.ints.unsigned
        );
        default = null;
        example = 10000;
        description = lib.mdDoc ''
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

      extraCmdlineOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Extra command line options to pass to bitcoind.
          Run bitcoind --help to list all available options.
        '';
      };
    };
  };
in
{

  options = {
    services.bitcoind = mkOption {
      type = types.attrsOf (types.submodule bitcoindOpts);
      default = {};
      description = lib.mdDoc "Specification of one or more bitcoind instances.";
    };
  };

  config = mkIf (eachBitcoind != {}) {

    assertions = flatten (mapAttrsToList (bitcoindName: cfg: [
    {
      assertion = (cfg.prune != null) -> (builtins.elem cfg.prune [ "disable" "manual" 0 1 ] || (builtins.isInt cfg.prune && cfg.prune >= 550));
      message = ''
        If set, services.bitcoind.${bitcoindName}.prune has to be "disable", "manual", 0 , 1 or >= 550.
      '';
    }
    {
      assertion = (cfg.rpc.users != {}) -> (cfg.configFile == null);
      message = ''
        You cannot set both services.bitcoind.${bitcoindName}.rpc.users and services.bitcoind.${bitcoindName}.configFile
        as they are exclusive. RPC user setting would have no effect if custom configFile would be used.
      '';
    }
    ]) eachBitcoind);

    environment.systemPackages = flatten (mapAttrsToList (bitcoindName: cfg: [
      cfg.package
    ]) eachBitcoind);

    systemd.services = mapAttrs' (bitcoindName: cfg: (
      nameValuePair "bitcoind-${bitcoindName}" (
      let
        configFile = pkgs.writeText "bitcoin.conf" ''
          # If Testnet is enabled, we need to add [test] section
          # otherwise, some options (e.g.: custom RPC port) will not work
          ${optionalString cfg.testnet "[test]"}
          # RPC users
          ${concatMapStringsSep  "\n"
            (rpcUser: "rpcauth=${rpcUser.name}:${rpcUser.passwordHMAC}")
            (attrValues cfg.rpc.users)
          }
          # Extra config options (from bitcoind nixos service)
          ${cfg.extraConfig}
        '';
      in {
        description = "Bitcoin daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = ''
            ${cfg.package}/bin/bitcoind \
            ${if (cfg.configFile != null) then
              "-conf=${cfg.configFile}"
            else
              "-conf=${configFile}"
            } \
            -datadir=${cfg.dataDir} \
            -pid=${cfg.pidFile} \
            ${optionalString cfg.testnet "-testnet"}\
            ${optionalString (cfg.port != null) "-port=${toString cfg.port}"}\
            ${optionalString (cfg.prune != null) "-prune=${toString cfg.prune}"}\
            ${optionalString (cfg.dbCache != null) "-dbcache=${toString cfg.dbCache}"}\
            ${optionalString (cfg.rpc.port != null) "-rpcport=${toString cfg.rpc.port}"}\
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
    ))) eachBitcoind;

    systemd.tmpfiles.rules = flatten (mapAttrsToList (bitcoindName: cfg: [
      "d '${cfg.dataDir}' 0770 '${cfg.user}' '${cfg.group}' - -"
    ]) eachBitcoind);

    users.users = mapAttrs' (bitcoindName: cfg: (
      nameValuePair "bitcoind-${bitcoindName}" {
      name = cfg.user;
      group = cfg.group;
      description = "Bitcoin daemon user";
      home = cfg.dataDir;
      isSystemUser = true;
    })) eachBitcoind;

    users.groups = mapAttrs' (bitcoindName: cfg: (
      nameValuePair "${cfg.group}" { }
    )) eachBitcoind;

  };

  meta.maintainers = with maintainers; [ _1000101 ];

}
