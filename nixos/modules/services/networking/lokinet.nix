{ config, lib, pkgs, ... }:

let
  inherit (lib) generators literalExample mkEnableOption mkIf mkOption recursiveUpdate types;
  cfg = config.services.lokinet;
  dataDir = "/var/lib/lokinet";
  lokinetDir = "${dataDir}/.lokinet";
  configFile = pkgs.writeText "lokinet.ini" (generators.toINI {} (recursiveUpdate defaultSettings cfg.settings));

  # default format generated using lokinet version 0.8.1: ${pkgs.lokinet}/bin/lokinet -g
  defaultSettings = with lib; {
    router = { }
      // optionalAttrs (cfg.router.netid != null) { netid = cfg.router.netid; }
      // optionalAttrs (cfg.router.minConnections != null) { min-connections = cfg.router.minConnections; }
      // optionalAttrs (cfg.router.maxConnections != null) { max-connections = cfg.router.maxConnections; }
      // optionalAttrs (cfg.router.dataDir != null) { data-dir = cfg.router.dataDir; }
      // optionalAttrs (cfg.router.workerThreads != null) { worker-threads = cfg.router.workerThreads; };

    network = { }
      // optionalAttrs (cfg.network.strictConnect != null) { strict-connect = cfg.network.strictConnect; }
      // optionalAttrs (cfg.network.keyFile != null) { key-file = cfg.network.keyFile; }
      // optionalAttrs (cfg.network.auth != null) { auth = cfg.network.auth; }
      // optionalAttrs (cfg.network.authLMQ != null) { auth-lmq = cfg.network.authLMQ; }
      // optionalAttrs (cfg.network.authLMQMethod != null) { auth-lmq-method = cfg.network.authLMQMethod; }
      // optionalAttrs (cfg.network.authWhitelist != null) { auth-whitelist = cfg.network.authWhitelist; }
      // optionalAttrs (cfg.network.reachable != null) { reachable = cfg.network.reachable; }
      // optionalAttrs (cfg.network.hops != null) { hops = cfg.network.hops; }
      // optionalAttrs (cfg.network.paths != null) { paths = cfg.network.paths; }
      // optionalAttrs (cfg.network.exit != null) { exit = cfg.network.exit; }
      // optionalAttrs (cfg.network.exitNode != null) { exit-node = cfg.network.exitNode; }
      // optionalAttrs (cfg.network.exitAuth != null) { exit-auth = cfg.network.exitAuth; }
      // optionalAttrs (cfg.network.ifName != null) { ifname = cfg.network.ifName; }
      // optionalAttrs (cfg.network.ifAddr != null) { ifaddr = cfg.network.ifAddr; }
      // optionalAttrs (cfg.network.mapAddr != null) { mapaddr = cfg.network.mapAddr; }
      // optionalAttrs (cfg.network.blacklistSnode != null) { blacklist-snode = cfg.network.blacklistSnode; }
      // optionalAttrs (cfg.network.srv != null) { srv = cfg.network.srv; };

    dns = { }
      // optionalAttrs (cfg.dns.upstream != null) { upstream = cfg.dns.upstream; }
      // optionalAttrs (cfg.dns.bind != null) { bind = cfg.dns.bind; }
      // optionalAttrs (cfg.dns.noResolvconf != null) { no-resolvconf = cfg.dns.noResolvconf; };

    bind = cfg.bind;

    api = { }
      // optionalAttrs (cfg.api.enabled != null) { enabled = cfg.api.enabled; }
      // optionalAttrs (cfg.api.bind != null) { bind = cfg.api.bind; };

    bootstrap = { }
      // optionalAttrs (cfg.bootstrap.seedNode != null) { seed-node = cfg.bootstrap.seedNode; }
      // optionalAttrs (cfg.bootstrap.addNode != null) { add-node = cfg.bootstrap.addNode; };

    logging = { }
      // optionalAttrs (cfg.logging.type != null) { type = cfg.logging.type; }
      // optionalAttrs (cfg.logging.level != null) { level = cfg.logging.level; }
      // optionalAttrs (cfg.logging.file != null) { file = cfg.logging.file; };
  };
in with lib; {
  options.services.lokinet = {
    enable = mkEnableOption "lokinet";

    settings = mkOption {
      type = with types; attrsOf (oneOf [ str int bool (listOf str) ]);
      default = {};
      example = literalExample "api.enabled = true;";

      description = ''
        <filename>lokinet.ini</filename> configuration. Refer to
        <link xlink:href="https://docs.loki.network/Lokinet/Guides/LokinetConfig/"/>
        for details on supported values;
      '';
    };

    router = mkOption {
      default = { };
      description = "Router configuration.";

      type = with types; submodule {
        options = {
          netid = mkOption {
            type = nullOr str;
            default = null;
            example = "lokinet";
            description = "Network ID; this is 'lokinet' for mainnet, 'gamma' for testnet.";
          };

          minConnections = mkOption {
            type = nullOr int;
            default = null;
            example = 4;
            description = "Minimum number of routers lokinet will attempt to maintain connections to.";
          };

          maxConnections = mkOption {
            type = nullOr int;
            default = null;
            example = 6;
            description = "Maximum number (hard limit) of routers lokinet will be connected to at any time.";
          };

          dataDir = mkOption {
            type = nullOr path;
            default = null;
            example = "${dataDir}";
            description = ''
              Directory for containing lokinet runtime data.
              This includes generated private keys.
            '';
          };

          workerThreads = mkOption {
            type = nullOr int;
            default = null;
            example = 0;
            description = ''
              The number of threads available for performing cryptographic functions.
              The minimum is one thread, but network performance may increase with more threads.
              Should not exceed the number of logical CPU cores.
              0 means use the number of logical CPU cores detected at startup.
            '';
          };
        };
      };
    };

    network = mkOption {
      default = { };
      description = "Network configuration.";

      type = with types; submodule {
        options = {
          strictConnect = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Public key of a router which will act as sole first-hop.
              This may be used to provide a trusted router (consider that you are not fully anonymous with your first hop).
            '';
          };

          keyFile = mkOption {
            type = nullOr path;
            default = null;
            description = ''
              The private key to persist address with.
              If not specified the address will be ephemeral.
            '';
          };

          auth = mkOption {
            type = nullOr (enum [ "none" "whitelist" "lmq" ]);
            default = null;
            example = "none";
            description = "Set the endpoint authentication mechanism.";
          };

          authLMQ = mkOption {
            type = nullOr str;
            default = null;
            example = "tcp://127.0.0.1:5555";
            description = "LMQ endpoint to talk to for authenticating new sessions.";
          };

          authLMQMethod = mkOption {
            type = nullOr str;
            default = null;
            example = "llarp.auth";
            description = "LMQ function to call for authenticating new sessions.";
          };

          authWhitelist = mkOption {
            type = nullOr str;
            default = null;
            description = "Add a remote endpoint by .loki address to the access whitelist.";
          };

          reachable = mkOption {
            type = nullOr bool;
            default = null;
            description = "Determines whether we will publish our snapp's introset to the DHT.";
          };

          hops = mkOption {
            type = nullOr int;
            default = null;
            example = 4;
            description = ''
              Number of hops in a path.
              Minimum: 1, Maximum: 8.
            '';
          };

          paths = mkOption {
            type = nullOr int;
            default = null;
            example = 6;
            description = "Number of paths to maintain at any given time.";
          };

          exit = mkOption {
            type = nullOr bool;
            default = null;
            description = ''
              Whether or not we should act as an exit node.
              Beware that this increases demand on the server and may pose liability concerns.
              Enable at your own risk.
            '';
          };

          exitNode = mkOption {
            type = nullOr str;
            default = null;
            example = "stuff.loki:100.0.0.0/24";
            description = "Specify a `.loki` address and an optional ip range to use as an exit broker.";
          };

          exitAuth = mkOption {
            type = nullOr (listOf str);
            default = null;
            example = [ "myfavouriteexit.loki:abc" ];
            description = "Specify an optional authentication code required to use a non-public exit node.";
          };

          ifName = mkOption {
            type = nullOr str;
            default = null;
            example = "lokinet0";
            description = "Interface name for lokinet traffic.";
          };

          ifAddr = mkOption {
            type = nullOr str;
            default = null;
            example = "172.16.0.1/16";
            description = "Local IP and range for lokinet traffic.";
          };

          mapAddr = mkOption {
            type = nullOr str;
            default = null;
            example = "whatever.loki:172.16.0.10";
            description = ''
              Map a remote `.loki` address to always use a fixed local IP.
              The given IP address must be inside the range configured by ifAddr.
            '';
          };

          blacklistSnode = mkOption {
            type = nullOr (listOf str);
            default = null;
            description = "Adds a lokinet relay `.snode` address to the list of relays to avoid when building paths.";
          };

          srv = mkOption {
            type = nullOr str;
            default = null;
            example = "_service._tcp 0 0 9345 target.loki";
            description = "Specify SRV Records for services hosted on the SNApp.";
          };
        };
      };
    };

    dns = mkOption {
      default = { };
      description = "DNS configuration.";

      type = with types; submodule {
        options = {
          upstream = mkOption {
            type = nullOr (listOf str);
            default = null;
            example = "1.1.1.1";
            description = "Upstream resolver(s) to use as fallback for non-loki addresses.";
          };

          bind = mkOption {
            type = nullOr str;
            default = null;
            example = "127.3.2.1:53";
            description = "Address to bind to for handling DNS requests.";
          };

          noResolvconf = mkOption {
            type = nullOr bool;
            default = null;
            description = "Disables resolvconf configuration of lokinet DNS.";
          };
        };
      };
    };

    bind = mkOption {
      type = with types; attrsOf (oneOf [ str int ]);
      default = { };
      example = literalExample "\"0.0.0.0\" = 1090;";
      description = "Specifies network interface names and/or IPs as keys, and ports as values to control the address(es) on which Lokinet listens for incoming data.";
    };

    api = mkOption {
      default = { };
      description = "JSON API configuration.";

      type = with types; submodule {
        options = {
          enabled = mkOption {
            type = nullOr bool;
            default = null;
            description = "Determines whether or not the LMQ JSON API is enabled.";
          };

          bind = mkOption {
            type = nullOr str;
            default = null;
            example = "tcp://127.0.0.1:1190";
            description = "IP address and port to bind the API to.";
          };
        };
      };
    };

    bootstrap = mkOption {
      default = { };
      description = "Configure nodes that will bootstrap us onto the network.";

      type = with types; submodule {
        options = {
          seedNode = mkOption {
            type = nullOr bool;
            default = null;
            description = "Whether or not to run as a seed node.";
          };

          addNode = mkOption {
            type = nullOr (listOf str);
            default = null;
            description = "Specify a bootstrap file containing a signed RouterContact of a service node which can act as a bootstrap.";
          };
        };
      };
    };

    logging = mkOption {
      default = { };
      description = "Logging configuration.";

      type = with types; submodule {
        options = {
          type = mkOption {
            type = nullOr (enum [ "file" "json" "syslog" ]);
            default = null;
            example = "file";
            description = "Log type (format).";
          };

          level = mkOption {
            type = nullOr (enum [ "trace" "debug" "info" "warn" "error" ]);
            default = null;
            example = "warn";
            description = ''
              Minimum log level to print.
              Logging below this level will be ignored.
            '';
          };

          file = mkOption {
            type = nullOr str;
            default = null;
            example = "lokinet";
            description = "Log output filename.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lokinet = {
      description = "lokinet";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.curl ];
      environment.HOME = dataDir;

      preStart = ''
        ${pkgs.lokinet}/bin/lokinet-bootstrap
        ln -sf ${configFile} ${lokinetDir}/lokinet.ini
      '';

      serviceConfig = {
        User = "lokinet";
        DynamicUser = true;
        StateDirectory = "lokinet";
        WorkingDirectory = dataDir;
        AmbientCapabilities = [ "cap_net_admin" "cap_net_bind_service" ];
        ExecStart = "${pkgs.lokinet}/bin/lokinet ${lokinetDir}/lokinet.ini";
      };
    };
  };

  meta.maintainers = with maintainers; [ chiiruno ];
}
