{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.rippled;
  opt = options.services.rippled;

  b2i = val: if val then "1" else "0";

  dbCfg = db: ''
    type=${db.type}
    path=${db.path}
    ${lib.optionalString (db.compression != null) ("compression=${b2i db.compression}")}
    ${lib.optionalString (db.onlineDelete != null) ("online_delete=${toString db.onlineDelete}")}
    ${lib.optionalString (db.advisoryDelete != null) ("advisory_delete=${b2i db.advisoryDelete}")}
    ${db.extraOpts}
  '';

  rippledCfg =
    ''
      [server]
      ${lib.concatMapStringsSep "\n" (n: "port_${n}") (lib.attrNames cfg.ports)}

      ${lib.concatMapStrings (p: ''
        [port_${p.name}]
        ip=${p.ip}
        port=${toString p.port}
        protocol=${lib.concatStringsSep "," p.protocol}
        ${lib.optionalString (p.user != "") "user=${p.user}"}
        ${lib.optionalString (p.password != "") "user=${p.password}"}
        admin=${lib.concatStringsSep "," p.admin}
        ${lib.optionalString (p.ssl.key != null) "ssl_key=${p.ssl.key}"}
        ${lib.optionalString (p.ssl.cert != null) "ssl_cert=${p.ssl.cert}"}
        ${lib.optionalString (p.ssl.chain != null) "ssl_chain=${p.ssl.chain}"}
      '') (lib.attrValues cfg.ports)}

      [database_path]
      ${cfg.databasePath}

      [node_db]
      ${dbCfg cfg.nodeDb}

      ${lib.optionalString (cfg.tempDb != null) ''
        [temp_db]
        ${dbCfg cfg.tempDb}''}

      ${lib.optionalString (cfg.importDb != null) ''
        [import_db]
        ${dbCfg cfg.importDb}''}

      [ips]
      ${lib.concatStringsSep "\n" cfg.ips}

      [ips_fixed]
      ${lib.concatStringsSep "\n" cfg.ipsFixed}

      [validators]
      ${lib.concatStringsSep "\n" cfg.validators}

      [node_size]
      ${cfg.nodeSize}

      [ledger_history]
      ${toString cfg.ledgerHistory}

      [fetch_depth]
      ${toString cfg.fetchDepth}

      [validation_quorum]
      ${toString cfg.validationQuorum}

      [sntp_servers]
      ${lib.concatStringsSep "\n" cfg.sntpServers}

      ${lib.optionalString cfg.statsd.enable ''
        [insight]
        server=statsd
        address=${cfg.statsd.address}
        prefix=${cfg.statsd.prefix}
      ''}

      [rpc_startup]
      { "command": "log_level", "severity": "${cfg.logLevel}" }
    ''
    + cfg.extraConfig;

  portOptions =
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          internal = true;
          default = name;
        };

        ip = lib.mkOption {
          default = "127.0.0.1";
          description = "Ip where rippled listens.";
          type = lib.types.str;
        };

        port = lib.mkOption {
          description = "Port where rippled listens.";
          type = lib.types.port;
        };

        protocol = lib.mkOption {
          description = "Protocols expose by rippled.";
          type = lib.types.listOf (
            lib.types.enum [
              "http"
              "https"
              "ws"
              "wss"
              "peer"
            ]
          );
        };

        user = lib.mkOption {
          description = "When set, these credentials will be required on HTTP/S requests.";
          type = lib.types.str;
          default = "";
        };

        password = lib.mkOption {
          description = "When set, these credentials will be required on HTTP/S requests.";
          type = lib.types.str;
          default = "";
        };

        admin = lib.mkOption {
          description = "A comma-separated list of admin IP addresses.";
          type = lib.types.listOf lib.types.str;
          default = [ "127.0.0.1" ];
        };

        ssl = {
          key = lib.mkOption {
            description = ''
              Specifies the filename holding the SSL key in PEM format.
            '';
            default = null;
            type = lib.types.nullOr lib.types.path;
          };

          cert = lib.mkOption {
            description = ''
              Specifies the path to the SSL certificate file in PEM format.
              This is not needed if the chain includes it.
            '';
            default = null;
            type = lib.types.nullOr lib.types.path;
          };

          chain = lib.mkOption {
            description = ''
              If you need a certificate chain, specify the path to the
              certificate chain here. The chain may include the end certificate.
            '';
            default = null;
            type = lib.types.nullOr lib.types.path;
          };
        };
      };
    };

  dbOptions = {
    options = {
      type = lib.mkOption {
        description = "Rippled database type.";
        type = lib.types.enum [
          "rocksdb"
          "nudb"
        ];
        default = "rocksdb";
      };

      path = lib.mkOption {
        description = "Location to store the database.";
        type = lib.types.path;
        default = cfg.databasePath;
        defaultText = lib.literalExpression "config.${opt.databasePath}";
      };

      compression = lib.mkOption {
        description = "Whether to enable snappy compression.";
        type = lib.types.nullOr lib.types.bool;
        default = null;
      };

      onlineDelete = lib.mkOption {
        description = "Enable automatic purging of older ledger information.";
        type = lib.types.nullOr (lib.types.addCheck lib.types.int (v: v > 256));
        default = cfg.ledgerHistory;
        defaultText = lib.literalExpression "config.${opt.ledgerHistory}";
      };

      advisoryDelete = lib.mkOption {
        description = ''
          If set, then require administrative RPC call "can_delete"
          to enable online deletion of ledger records.
        '';
        type = lib.types.nullOr lib.types.bool;
        default = null;
      };

      extraOpts = lib.mkOption {
        description = "Extra database options.";
        type = lib.types.lines;
        default = "";
      };
    };
  };

in

{

  ###### interface

  options = {
    services.rippled = {
      enable = lib.mkEnableOption "rippled, a decentralized cryptocurrency blockchain daemon implementing the XRP Ledger protocol in C++";

      package = lib.mkPackageOption pkgs "rippled" { };

      ports = lib.mkOption {
        description = "Ports exposed by rippled";
        type = with lib.types; attrsOf (submodule portOptions);
        default = {
          rpc = {
            port = 5005;
            admin = [ "127.0.0.1" ];
            protocol = [ "http" ];
          };

          peer = {
            port = 51235;
            ip = "0.0.0.0";
            protocol = [ "peer" ];
          };

          ws_public = {
            port = 5006;
            ip = "0.0.0.0";
            protocol = [
              "ws"
              "wss"
            ];
          };
        };
      };

      nodeDb = lib.mkOption {
        description = "Rippled main database options.";
        type = with lib.types; nullOr (submodule dbOptions);
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

      tempDb = lib.mkOption {
        description = "Rippled temporary database options.";
        type = with lib.types; nullOr (submodule dbOptions);
        default = null;
      };

      importDb = lib.mkOption {
        description = "Settings for performing a one-time import.";
        type = with lib.types; nullOr (submodule dbOptions);
        default = null;
      };

      nodeSize = lib.mkOption {
        description = ''
          Rippled size of the node you are running.
          "tiny", "small", "medium", "large", and "huge"
        '';
        type = lib.types.enum [
          "tiny"
          "small"
          "medium"
          "large"
          "huge"
        ];
        default = "small";
      };

      ips = lib.mkOption {
        description = ''
          List of hostnames or ips where the Ripple protocol is served.
          For a starter list, you can either copy entries from:
          https://ripple.com/ripple.txt or if you prefer you can let it
           default to r.ripple.com 51235

          A port may optionally be specified after adding a space to the
          address. By convention, if known, IPs are listed in from most
          to least trusted.
        '';
        type = lib.types.listOf lib.types.str;
        default = [ "r.ripple.com 51235" ];
      };

      ipsFixed = lib.mkOption {
        description = ''
          List of IP addresses or hostnames to which rippled should always
          attempt to maintain peer connections with. This is useful for
          manually forming private networks, for example to configure a
          validation server that connects to the Ripple network through a
          public-facing server, or for building a set of cluster peers.

          A port may optionally be specified after adding a space to the address
        '';
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      validators = lib.mkOption {
        description = ''
          List of nodes to always accept as validators. Nodes are specified by domain
          or public key.
        '';
        type = lib.types.listOf lib.types.str;
        default = [
          "n949f75evCHwgyP4fPVgaHqNHxUVN15PsJEZ3B3HnXPcPjcZAoy7  RL1"
          "n9MD5h24qrQqiyBC8aeqqCWvpiBiYQ3jxSr91uiDvmrkyHRdYLUj  RL2"
          "n9L81uNCaPgtUJfaHh89gmdvXKAmSt5Gdsw2g1iPWaPkAHW5Nm4C  RL3"
          "n9KiYM9CgngLvtRCQHZwgC2gjpdaZcCcbt3VboxiNFcKuwFVujzS  RL4"
          "n9LdgEtkmGB9E2h3K4Vp7iGUaKuq23Zr32ehxiU8FWY7xoxbWTSA  RL5"
        ];
      };

      databasePath = lib.mkOption {
        description = ''
          Path to the ripple database.
        '';
        type = lib.types.path;
        default = "/var/lib/rippled";
      };

      validationQuorum = lib.mkOption {
        description = ''
          The minimum number of trusted validations a ledger must have before
          the server considers it fully validated.
        '';
        type = lib.types.int;
        default = 3;
      };

      ledgerHistory = lib.mkOption {
        description = ''
          The number of past ledgers to acquire on server startup and the minimum
          to maintain while running.
        '';
        type = lib.types.either lib.types.int (lib.types.enum [ "full" ]);
        default = 1296000; # 1 month
      };

      fetchDepth = lib.mkOption {
        description = ''
          The number of past ledgers to serve to other peers that request historical
          ledger data (or "full" for no limit).
        '';
        type = lib.types.either lib.types.int (lib.types.enum [ "full" ]);
        default = "full";
      };

      sntpServers = lib.mkOption {
        description = ''
          IP address or domain of NTP servers to use for time synchronization.;
        '';
        type = lib.types.listOf lib.types.str;
        default = [
          "time.windows.com"
          "time.apple.com"
          "time.nist.gov"
          "pool.ntp.org"
        ];
      };

      logLevel = lib.mkOption {
        description = "Logging verbosity.";
        type = lib.types.enum [
          "debug"
          "error"
          "info"
        ];
        default = "error";
      };

      statsd = {
        enable = lib.mkEnableOption "statsd monitoring for rippled";

        address = lib.mkOption {
          description = "The UDP address and port of the listening StatsD server.";
          default = "127.0.0.1:8125";
          type = lib.types.str;
        };

        prefix = lib.mkOption {
          description = "A string prepended to each collected metric.";
          default = "";
          type = lib.types.str;
        };
      };

      extraConfig = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Extra lines to be added verbatim to the rippled.cfg configuration file.
        '';
      };

      config = lib.mkOption {
        internal = true;
        default = pkgs.writeText "rippled.conf" rippledCfg;
        defaultText = lib.literalMD "generated config file";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users.rippled = {
      description = "Ripple server user";
      isSystemUser = true;
      group = "rippled";
      home = cfg.databasePath;
      createHome = true;
    };
    users.groups.rippled = { };

    systemd.services.rippled = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rippled --fg --conf ${cfg.config}";
        User = "rippled";
        Restart = "on-failure";
        LimitNOFILE = 10000;
      };
    };

    environment.systemPackages = [ cfg.package ];

  };
}
