{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.bitcoind;
  pidFile = "${cfg.dataDir}/bitcoind.pid";
  configFile = pkgs.writeText "bitcoin.conf" ''
    ${optionalString cfg.testnet "testnet=1"}
    ${optionalString (cfg.dbCache != null) "dbcache=${toString cfg.dbCache}"}
    ${optionalString (cfg.prune != null) "prune=${toString cfg.prune}"}

    # Connection options
    ${optionalString (cfg.port != null) "port=${toString cfg.port}"}

    # RPC server options
    ${optionalString (cfg.rpc.port != null) "rpcport=${toString cfg.rpc.port}"}
    ${concatMapStringsSep  "\n"
      (rpcUser: "rpcauth=${rpcUser.name}:${rpcUser.passwordHMAC}")
      (attrValues cfg.rpc.users)
    }

    # Extra config options (from bitcoind nixos service)
    ${cfg.extraConfig}
  '';
  cmdlineOptions = escapeShellArgs [
    "-conf=${cfg.configFile}"
    "-datadir=${cfg.dataDir}"
    "-pid=${pidFile}"
  ];

  rpcUserOpts = { name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        example = "alice";
        description = ''
          Username for JSON-RPC connections.
        '';
      };
      passwordHMAC = mkOption {
        type = with types; uniq (strMatching "[0-9a-f]+\\$[0-9a-f]{64}");
        example = "f7efda5c189b999524f151318c0c86$d5b51b3beffbc02b724e5d095828e0bc8b2456e9ac8757ae3211a5d9b16a22ae";
        description = ''
          Password HMAC-SHA-256 for JSON-RPC connections. Must be a string of the
          format &lt;SALT-HEX&gt;$&lt;HMAC-HEX&gt;.
        '';
      };
    };
    config = {
      name = mkDefault name;
    };
  };
in {
  options = {

    services.bitcoind = {
      enable = mkEnableOption "Bitcoin daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.bitcoind;
        defaultText = "pkgs.bitcoind";
        description = "The package providing bitcoin binaries.";
      };
      configFile = mkOption {
        type = types.path;
        default = configFile;
        example = "/etc/bitcoind.conf";
        description = "The configuration file path to supply bitcoind.";
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          par=16
          rpcthreads=16
          logips=1
        '';
        description = "Additional configurations to be appended to <filename>bitcoin.conf</filename>.";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/bitcoind";
        description = "The data directory for bitcoind.";
      };

      user = mkOption {
        type = types.str;
        default = "bitcoin";
        description = "The user as which to run bitcoind.";
      };
      group = mkOption {
        type = types.str;
        default = cfg.user;
        description = "The group as which to run bitcoind.";
      };

      rpc = {
        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "Override the default port on which to listen for JSON-RPC connections.";
        };
        users = mkOption {
          default = {};
          example = literalExample ''
            {
              alice.passwordHMAC = "f7efda5c189b999524f151318c0c86$d5b51b3beffbc02b724e5d095828e0bc8b2456e9ac8757ae3211a5d9b16a22ae";
              bob.passwordHMAC = "b2dd077cb54591a2f3139e69a897ac$4e71f08d48b4347cf8eff3815c0e25ae2e9a4340474079f55705f40574f4ec99";
            }
          '';
          type = with types; loaOf (submodule rpcUserOpts);
          description = ''
            RPC user information for JSON-RPC connnections.
          '';
        };
      };

      testnet = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use the test chain.";
      };
      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = "Override the default port on which to listen for connections.";
      };
      dbCache = mkOption {
        type = types.nullOr (types.ints.between 4 16384);
        default = null;
        example = 4000;
        description = "Override the default database cache size in megabytes.";
      };
      prune = mkOption {
        type = types.nullOr (types.coercedTo
          (types.enum [ "disable" "manual" ])
          (x: if x == "disable" then 0 else 1)
          types.ints.unsigned
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
          to stay under the specified target size in MiB)
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 '${cfg.user}' '${cfg.group}' - -"
      "L '${cfg.dataDir}/bitcoin.conf' - - - - '${cfg.configFile}'"
    ];
    systemd.services.bitcoind = {
      description = "Bitcoin daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/bitcoind ${cmdlineOptions}";
        Restart = "on-failure";

        # Hardening measures
        PrivateTmp = "true";
        ProtectSystem = "full";
        NoNewPrivileges = "true";
        PrivateDevices = "true";
        MemoryDenyWriteExecute = "true";
      };
    };
    users.users.${cfg.user} = {
      name = cfg.user;
      group = cfg.group;
      description = "Bitcoin daemon user";
      home = cfg.dataDir;
      isSystemUser = true;
    };
    users.groups.${cfg.group} = {
      name = cfg.group;
    };
  };
}
