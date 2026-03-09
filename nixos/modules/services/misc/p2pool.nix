{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.p2pool;

  # Generate the params file content.
  # Format: "param-name = value" or "param-name = 1" for booleans.
  # Strings with spaces need quotes.
  configLines = lib.concatStringsSep "\n" (
    lib.filter (x: x != "") [
      "wallet = ${cfg.wallet}"
      "host = ${cfg.host}"
      "rpc-port = ${toString cfg.rpcPort}"
      "zmq-port = ${toString cfg.zmqPort}"
      "data-dir = /var/lib/p2pool"
      "no-color = 1"
      (lib.optionalString (cfg.stratum != [ ]) "stratum = ${lib.concatStringsSep "," cfg.stratum}")
      (lib.optionalString (cfg.p2p != [ ]) "p2p = ${lib.concatStringsSep "," cfg.p2p}")
      (lib.optionalString (cfg.addPeers != [ ]) "addpeers = ${lib.concatStringsSep "," cfg.addPeers}")
      (lib.optionalString cfg.lightMode "light-mode = 1")
      (lib.optionalString cfg.mini "mini = 1")
      (lib.optionalString cfg.nano "nano = 1")
      (lib.optionalString cfg.noDns "no-dns = 1")
      (lib.optionalString (cfg.loglevel != null) "loglevel = ${toString cfg.loglevel}")
      (lib.optionalString (cfg.outPeers != null) "out-peers = ${toString cfg.outPeers}")
      (lib.optionalString (cfg.inPeers != null) "in-peers = ${toString cfg.inPeers}")
      (lib.optionalString (cfg.dataApi != null) "data-api = \"${cfg.dataApi}\"")
      (lib.optionalString cfg.localApi "local-api = 1")
    ]
    ++ cfg.extraConfig
  );

  # Write the base config file (without secrets) to the Nix store.
  configFile = pkgs.writeText "p2pool.conf" configLines;
in
{
  options = {
    services.p2pool = {
      enable = lib.mkEnableOption "p2pool, a decentralized pool for Monero mining";

      package = lib.mkPackageOption pkgs "p2pool" { };

      wallet = lib.mkOption {
        type = lib.types.strMatching "^[48][1-9A-HJ-NP-Za-km-z]{94}$";
        description = "Monero wallet address for receiving mining rewards.";
        example = "44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVGQBEP3A";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "IP address of the Monero node (monerod).";
      };

      rpcPort = lib.mkOption {
        type = lib.types.port;
        default = 18081;
        description = "monerod RPC API port number.";
      };

      zmqPort = lib.mkOption {
        type = lib.types.port;
        default = 18083;
        description = "monerod ZMQ pub port number.";
      };

      stratum = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "0.0.0.0:3333" ];
        description = "List of IP:port for the stratum server to listen on.";
      };

      p2p = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "0.0.0.0:37889" ];
        description = "List of IP:port for the p2p server to listen on.";
      };

      addPeers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of IP:port of other p2pool nodes to connect to.";
        example = [
          "node.example.com:37889"
        ];
      };

      lightMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Don't allocate RandomX dataset, saves 2 GiB of RAM.";
      };

      mini = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Connect to p2pool-mini sidechain. Note that it will also change default p2p port from 37889 to 37888.";
      };

      nano = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Connect to p2pool-nano sidechain. Note that it will also change default p2p port from 37889 to 37890.";
      };

      noDns = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable DNS queries, use only IP addresses to connect to peers.";
      };

      loglevel = lib.mkOption {
        type = lib.types.nullOr (lib.types.ints.between 0 6);
        default = null;
        description = "Verbosity of the log, integer number between 0 and 6.";
      };

      outPeers = lib.mkOption {
        type = lib.types.nullOr (lib.types.ints.between 10 450);
        default = null;
        description = "Maximum number of outgoing connections for the p2p server.";
      };

      inPeers = lib.mkOption {
        type = lib.types.nullOr (lib.types.ints.between 10 450);
        default = null;
        description = "Maximum number of incoming connections for the p2p server.";
      };

      dataApi = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/p2pool/api";
        description = ''
          Path to the p2pool JSON data for use with an external web server.
          When using the default DynamicUser, this path must be under
          `/var/lib/p2pool/` to be writable by the service.
        '';
      };

      localApi = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable /local/ path in the API for stratum server and built-in miner statistics.";
      };

      rpcLoginFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/p2pool-rpc-login";
        description = ''
          Path to a file containing the RPC login credentials in
          `username:password` format for authenticating with monerod.

          The file contents are securely loaded via systemd's
          `LoadCredential` and never appear in the process command line
          or Nix store.

          Example file contents:
          ```
          user:secretpassword
          ```
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "no-upnp = 1" ];
        description = ''
          Additional lines to append to the p2pool configuration file.
          Each string should be in `param = value` format.

          See [p2pool documentation](https://github.com/SChernykh/p2pool/blob/master/docs/COMMAND_LINE.MD)
          for available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.mini && cfg.nano);
        message = "services.p2pool.mini and services.p2pool.nano are mutually exclusive";
      }
    ];

    systemd.services.p2pool = {
      description = "P2Pool Monero Mining";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Copy base config to runtime directory
        install -m 600 ${configFile} "$RUNTIME_DIRECTORY/p2pool.conf"

        # Append RPC login from credential if provided
        ${lib.optionalString (cfg.rpcLoginFile != null) ''
          echo "rpc-login = $(cat "$CREDENTIALS_DIRECTORY/rpc-login")" >> "$RUNTIME_DIRECTORY/p2pool.conf"
        ''}
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --params-file \${RUNTIME_DIRECTORY}/p2pool.conf";
        DynamicUser = true;
        StateDirectory = "p2pool";
        RuntimeDirectory = "p2pool";
        Restart = "always";
        RestartSec = 10;

        LoadCredential = lib.optional (cfg.rpcLoginFile != null) "rpc-login:${cfg.rpcLoginFile}";

        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ titaniumtown ];
}
