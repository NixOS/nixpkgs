{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rippled;

  b2i = val: if val then "1" else "0";

  dbCfg = db: ''
    type=${db.type}
    path=${db.path}
    ${optionalString (db.compression != null) ("compression=${b2i db.compression}") }
    ${optionalString (db.onlineDelete != null) ("online_delete=${toString db.onlineDelete}")}
    ${optionalString (db.advisoryDelete != null) ("advisory_delete=${b2i db.advisoryDelete}")}
    ${db.extraOpts}
  '';

  rippledCfg = ''
    [server]
    ${concatMapStringsSep "\n" (n: "port_${n}") (attrNames cfg.ports)}

    ${concatMapStrings (p: ''
    [port_${p.name}]
    ip=${p.ip}
    port=${toString p.port}
    protocol=${concatStringsSep "," p.protocol}
    ${optionalString (p.user != "") "user=${p.user}"}
    ${optionalString (p.password != "") "user=${p.password}"}
    admin=${concatStringsSep "," p.admin}
    ${optionalString (p.ssl.key != null) "ssl_key=${p.ssl.key}"}
    ${optionalString (p.ssl.cert != null) "ssl_cert=${p.ssl.cert}"}
    ${optionalString (p.ssl.chain != null) "ssl_chain=${p.ssl.chain}"}
    '') (attrValues cfg.ports)}

    [database_path]
    ${cfg.databasePath}

    [node_db]
    ${dbCfg cfg.nodeDb}

    ${optionalString (cfg.tempDb != null) ''
    [temp_db]
    ${dbCfg cfg.tempDb}''}

    ${optionalString (cfg.importDb != null) ''
    [import_db]
    ${dbCfg cfg.importDb}''}

    [ips]
    ${concatStringsSep "\n" cfg.ips}

    [ips_fixed]
    ${concatStringsSep "\n" cfg.ipsFixed}

    [validators]
    ${concatStringsSep "\n" cfg.validators}

    [node_size]
    ${cfg.nodeSize}

    [ledger_history]
    ${toString cfg.ledgerHistory}

    [fetch_depth]
    ${toString cfg.fetchDepth}

    [validation_quorum]
    ${toString cfg.validationQuorum}

    [sntp_servers]
    ${concatStringsSep "\n" cfg.sntpServers}

    ${optionalString cfg.statsd.enable ''
    [insight]
    server=statsd
    address=${cfg.statsd.address}
    prefix=${cfg.statsd.prefix}
    ''}

    [rpc_startup]
    { "command": "log_level", "severity": "${cfg.logLevel}" }
  '' + cfg.extraConfig;

  portOptions = { name, ...}: {
    options = {
      name = mkOption {
        internal = true;
        default = name;
      };

      ip = mkOption {
        default = "127.0.0.1";
        description = "Ip where rippled listens.";
        type = types.str;
      };

      port = mkOption {
        description = "Port where rippled listens.";
        type = types.int;
      };

      protocol = mkOption {
        description = "Protocols expose by rippled.";
        type = types.listOf (types.enum ["http" "https" "ws" "wss" "peer"]);
      };

      user = mkOption {
        description = "When set, these credentials will be required on HTTP/S requests.";
        type = types.str;
        default = "";
      };

      password = mkOption {
        description = "When set, these credentials will be required on HTTP/S requests.";
        type = types.str;
        default = "";
      };

      admin = mkOption {
        description = "A comma-separated list of admin IP addresses.";
        type = types.listOf types.str;
        default = ["127.0.0.1"];
      };

      ssl = {
        key = mkOption {
          description = ''
            Specifies the filename holding the SSL key in PEM format.
          '';
          default = null;
          type = types.nullOr types.path;
        };

        cert = mkOption {
          description = ''
            Specifies the path to the SSL certificate file in PEM format.
            This is not needed if the chain includes it.
          '';
          default = null;
          type = types.nullOr types.path;
        };

        chain = mkOption {
          description = ''
            If you need a certificate chain, specify the path to the
            certificate chain here. The chain may include the end certificate.
          '';
          default = null;
          type = types.nullOr types.path;
        };
      };
    };
  };

  dbOptions = {
    options = {
      type = mkOption {
        description = "Rippled database type.";
        type = types.enum ["rocksdb" "nudb"];
        default = "rocksdb";
      };

      path = mkOption {
        description = "Location to store the database.";
        type = types.path;
        default = cfg.databasePath;
      };

      compression = mkOption {
        description = "Whether to enable snappy compression.";
        type = types.nullOr types.bool;
        default = null;
      };

      onlineDelete = mkOption {
        description = "Enable automatic purging of older ledger information.";
        type = types.nullOr (types.addCheck types.int (v: v > 256));
        default = cfg.ledgerHistory;
      };

      advisoryDelete = mkOption {
        description = ''
          If set, then require administrative RPC call "can_delete"
          to enable online deletion of ledger records.
        '';
        type = types.nullOr types.bool;
        default = null;
      };

      extraOpts = mkOption {
        description = "Extra database options.";
        type = types.lines;
        default = "";
      };
    };
  };

in

{

  ###### interface

  options = {
    services.rippled = {
      enable = mkEnableOption "rippled";

      package = mkOption {
        description = "Which rippled package to use.";
        type = types.package;
        default = pkgs.rippled;
        defaultText = "pkgs.rippled";
      };

      ports = mkOption {
        description = "Ports exposed by rippled";
        type = with types; attrsOf (submodule portOptions);
        default = {
          rpc = {
            port = 5005;
            admin = ["127.0.0.1"];
            protocol = ["http"];
          };

          peer = {
            port = 51235;
            ip = "0.0.0.0";
            protocol = ["peer"];
          };

          ws_public = {
            port = 5006;
            ip = "0.0.0.0";
            protocol = ["ws" "wss"];
          };
        };
      };

      nodeDb = mkOption {
        description = "Rippled main database options.";
        type = with types; nullOr (submodule dbOptions);
        default = {
          type = "rocksdb";
          extraOpts = ''
            open_files=2000
            filter_bits=12
            cache_mb=256
            file_size_pb=8
            file_size_mult=2;
          '';
        };
      };

      tempDb = mkOption {
        description = "Rippled temporary database options.";
        type = with types; nullOr (submodule dbOptions);
        default = null;
      };

      importDb = mkOption {
        description = "Settings for performing a one-time import.";
        type = with types; nullOr (submodule dbOptions);
        default = null;
      };

      nodeSize = mkOption {
        description = ''
          Rippled size of the node you are running.
          "tiny", "small", "medium", "large", and "huge"
        '';
        type = types.enum ["tiny" "small" "medium" "large" "huge"];
        default = "small";
      };

      ips = mkOption {
        description = ''
          List of hostnames or ips where the Ripple protocol is served.
          For a starter list, you can either copy entries from:
          https://ripple.com/ripple.txt or if you prefer you can let it
           default to r.ripple.com 51235

          A port may optionally be specified after adding a space to the
          address. By convention, if known, IPs are listed in from most
          to least trusted.
        '';
        type = types.listOf types.str;
        default = ["r.ripple.com 51235"];
      };

      ipsFixed = mkOption {
        description = ''
          List of IP addresses or hostnames to which rippled should always
          attempt to maintain peer connections with. This is useful for
          manually forming private networks, for example to configure a
          validation server that connects to the Ripple network through a
          public-facing server, or for building a set of cluster peers.

          A port may optionally be specified after adding a space to the address
        '';
        type = types.listOf types.str;
        default = [];
      };

      validators = mkOption {
        description = ''
          List of nodes to always accept as validators. Nodes are specified by domain
          or public key.
        '';
        type = types.listOf types.str;
        default = [
          "n949f75evCHwgyP4fPVgaHqNHxUVN15PsJEZ3B3HnXPcPjcZAoy7  RL1"
          "n9MD5h24qrQqiyBC8aeqqCWvpiBiYQ3jxSr91uiDvmrkyHRdYLUj  RL2"
          "n9L81uNCaPgtUJfaHh89gmdvXKAmSt5Gdsw2g1iPWaPkAHW5Nm4C  RL3"
          "n9KiYM9CgngLvtRCQHZwgC2gjpdaZcCcbt3VboxiNFcKuwFVujzS  RL4"
          "n9LdgEtkmGB9E2h3K4Vp7iGUaKuq23Zr32ehxiU8FWY7xoxbWTSA  RL5"
        ];
      };

      databasePath = mkOption {
        description = ''
          Path to the ripple database.
        '';
        type = types.path;
        default = "/var/lib/rippled";
      };

      validationQuorum = mkOption {
        description = ''
          The minimum number of trusted validations a ledger must have before
          the server considers it fully validated.
        '';
        type = types.int;
        default = 3;
      };

      ledgerHistory = mkOption {
        description = ''
          The number of past ledgers to acquire on server startup and the minimum
          to maintain while running.
        '';
        type = types.either types.int (types.enum ["full"]);
        default = 1296000; # 1 month
      };

      fetchDepth = mkOption {
        description = ''
          The number of past ledgers to serve to other peers that request historical
          ledger data (or "full" for no limit).
        '';
        type = types.either types.int (types.enum ["full"]);
        default = "full";
      };

      sntpServers = mkOption {
        description = ''
          IP address or domain of NTP servers to use for time synchronization.;
        '';
        type = types.listOf types.str;
        default = [
          "time.windows.com"
          "time.apple.com"
          "time.nist.gov"
          "pool.ntp.org"
        ];
      };

      logLevel = mkOption {
        description = "Logging verbosity.";
        type = types.enum ["debug" "error" "info"];
        default = "error";
      };

      statsd = {
        enable = mkEnableOption "statsd monitoring for rippled";

        address = mkOption {
          description = "The UDP address and port of the listening StatsD server.";
          default = "127.0.0.1:8125";
          type = types.str;
        };

        prefix = mkOption {
          description = "A string prepended to each collected metric.";
          default = "";
          type = types.str;
        };
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Extra lines to be added verbatim to the rippled.cfg configuration file.
        '';
      };

      config = mkOption {
        internal = true;
        default = pkgs.writeText "rippled.conf" rippledCfg;
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users = singleton
      { name = "rippled";
        description = "Ripple server user";
        uid = config.ids.uids.rippled;
        home = cfg.databasePath;
        createHome = true;
      };

    systemd.services.rippled = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rippled --fg --conf ${cfg.config}";
        User = "rippled";
        Restart = "on-failure";
        LimitNOFILE=10000;
      };
    };

    environment.systemPackages = [ cfg.package ];

  };
}
