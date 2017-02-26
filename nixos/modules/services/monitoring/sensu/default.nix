{ config, pkgs, lib, ... }:

let
  cfg = config.services.sensu;
  pgm = cfg.programs;

  baseDir = "/etc/sensu";

  transportIsRabbitMQ = (cfg.transport.name == "rabbitmq");
  roleIsServer = (cfg.role == "server");

  # Setting the LOG_LEVEL env var doesn't work, so we force the logLevel via -L
  bin = binary: lib.concatStringsSep " " [
    "${cfg.package}/bin/sensu-${binary}"
    "-c ${baseDir}/config.json"
    "-d ${baseDir}/conf.d"
    "-e ${baseDir}/extensions"
    "-L ${cfg.logLevel}"
  ];

  # Create a dedicated environment to allow for very long paths as systemd has a
  # 2048 character limit
  clientEnv = pkgs.buildEnv {
    name = "sensu-env";
    pathsToLink = [ "/bin" ];
    paths = (with pkgs; [ gawk ]
      ++ lib.optionals pgm.common  [ nagiosPluginsOfficial ] # this needs renaming to monitoring-plugins when it hits stable
      ++ lib.optionals pgm.esx     [ check-esx-hardware ] # change to esxi
      ++ lib.optionals pgm.http    [ curl ]
      ++ lib.optionals pgm.ipmi    [ ipmitool which ]
      ++ lib.optionals pgm.openvpn [ sensu-check-openvpn ]
      ++ lib.optionals pgm.snmp    [ net_snmp ]);
  };

  sensuService = desc: bin:
  let
    pgm = lib.toLower desc;
    isClient = lib.elem pgm [ "client" ];
    isDash   = lib.elem pgm [ "dashboard" ];
    isServer = lib.elem pgm [ "server" "api" ];
  in {
    description = "Sensu ${desc}";
    wantedBy    = [ "sensu.target" ];
    after       = [] ++ lib.optionals isServer [ "redis.service" "rabbmitmq.service" ];
    # Sensu is very shell-happy. I don't know if it actually requires bash, but
    # it definitely needs a shell.
    path        = [ pkgs.bash cfg.package ] ++ cfg.dependencies ++ lib.optional isClient clientEnv;
    # Needed for bundler
    environment.HOME = "/tmp";

    restartTriggers = [ ]
      ++ lib.optionals isClient [ sensuCfg clientCfg ]
      ++ lib.optionals isDash   [ dashCfg ]
      ++ lib.optionals isServer [ sensuCfg checkCfg handlerCfg ];
    serviceConfig = {
      ExecStart        = bin;
      # If you backport this to 17.03, DynamicUser WILL cause certain checks to
      # fail as they expect to be able to resolve uid -> user name and the
      # required NSS module isn't loaded (it is in master).
      DynamicUser      = true;
      Slice            = "sensu.slice";
      Restart          = "on-failure";
      # Upstream recommends 1m which seems VERY long
      RestartSec       = "10s";
      ProtectSystem    = "full";
      ProtectHome      = true;
      # Sensu expects a common file in /tmp which must be shared with the other
      # sensu units this can be enabled when our systemd module gets support for
      # JoinsNamespaceOf.
      PrivateTmp       = false;
    };
  };

  # This function serves two purposes:
  #
  # 1) We do a lot of attrs -> json but nix will add a "_module" key when
  #    dumping a submodule which is at best noise and in the worst case causes
  #    an unexpected setting to be set
  #
  # 2) We do not want to set defaults for everything (as defaults change), so if
  #    a value is an empty string|list|set, we simply remove the key from the
  #    generated JSON to allow sensu to apply its own defaults

  cleanAttrSet = set_or_list:
    if builtins.isList set_or_list
      then (map (s: cleanAttrSet s) set_or_list)
      else lib.filterAttrsRecursive (k: v:
            !(k == "_module" || v == "" || v == [] || v == {})) set_or_list;

  checkCfg = pkgs.writeText "checks.json" (builtins.toJSON (cleanAttrSet {
    inherit (cfg) checks;
  }));

  handlerCfg = pkgs.writeText "handlers.json" (builtins.toJSON (cleanAttrSet {
    inherit (cfg) handlers;
  } // cfg.plugins));

  mutatorCfg = pkgs.writeText "mutators.json" (builtins.toJSON (cleanAttrSet {
    inherit (cfg) mutators;
  }));

  sensuCfg = let
    rabbitmq = cleanAttrSet cfg.rabbitmq;
  in pkgs.writeText "config.json" (builtins.toJSON ({
    inherit rabbitmq;
  } // (cleanAttrSet (if roleIsServer
    then { inherit (cfg) api extensions influxdb mutators redis transport; } # mutators
    else { inherit (cfg)                                        transport; }))));

  clientCfg = pkgs.writeText "client.json" (builtins.toJSON (cleanAttrSet {
    inherit (cfg) client;
  }));

  dashCfg = pkgs.writeText "uchiwa.json" (builtins.toJSON (cleanAttrSet {
    sensu = cleanAttrSet cfg.sites;
    uchiwa = cfg.dashboard // {
      loglevel = cfg.logLevel;
    };
  }));

  # Currently not used
  makePlugin = name: config: base:
    let
      fileName = "plugin-${name}.json";
    in {
      source = pkgs.writeText fileName (builtins.toJSON { "${name}" = config; });
      target = "${base}/${fileName}";
    };

in {

  options = {
    services.sensu = with lib; with types; {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Enable the Sensu network monitoring daemon.
        '';
      };

      # Add support for dashboard rabbitmq redis etc
      role = mkOption {
        # type = listOf enum [ "server" "client" "dashboard" "influxdb" "rabbmitmq" "redis" ];
        type = enum [ "server" "client" ];
        # default = [ "server" ];
        default = "server";
        description = "Operate as client only or server and client.";
      };

      transport = mkOption {
        default = {};
        description = "The transport.";
        type = submodule {
          options = {
            name = mkOption {
              type = enum [ "redis" "rabbitmq" ];
              default = "redis";
              description = "The transport to use.";
            };

            reconnect_on_error = mkOption {
              type = bool;
              default = true;
              description = "Automatically reconnect on error.";
            };
          };
        };
      };

      openDefaultPorts = mkOption {
        type = bool;
        default = false;
        description = "Automatically open the firewall ports.";
      };

      defaultClientSubscriptions = mkOption {
        type = listOf str;
        default = [ "sensu-client" ];
        description = "Default subscriptions for sensu clients.";
      };

      defaultServerSubscriptions = mkOption {
        type = listOf str;
        default = [ "sensu-server" ];
        description = "Default subscriptions for sensu servers.";
      };

      addDefaultSubscriptions = mkOption {
        type = bool;
        default = false;
        description = "Add default checks of the sensu environment.";
      };

      package = mkOption {
        type = package;
        default = pkgs.sensu;
        description = "The package to use.";
      };

      dependencies = mkOption {
        type = listOf package;
        default = [];
        description = "Additional packages to inject into the path.";
      };

      logLevel = mkOption {
        type = enum [ "debug" "info" "warn" "error" "fatal" ];
        default = "info";
        description = ''The level of logging. The default info is VERY verbose
          and you probably want to change this to 'warn' when things are working
        '';
      };

      extensions = mkOption {
        type = attrs;
        default = {};
        description = "Extensions to load.";
      };

      redis = mkOption {
        description = "Redis configuration.";
        default = {};
        type = (submodule (import ./host_port_pair.nix {
          inherit lib;
          name = "redis";
          defaultHost = "127.0.0.1";
          defaultPort = 6379;
        }));
      };

      influxdb = mkOption {
        description = "InfluxDB configuration.";
        default = {};
        type = (submodule (import ./host_port_pair.nix {
            inherit lib;
            name = "influxdb";
            defaultHost = "localhost";
            defaultPort = 8086;
            options = {
              database = mkOption {
                default = "sensu";
                description = "InfluxDB database";
                type = str;
              };

              user = mkOption {
                default = null;
                description = "InfluxDB user";
                type = nullOr str;
              };

              password = mkOption {
                default = null;
                description = "InfluxDB password";
                type = nullOr str;
              };
            };
        }));
      };

      rabbitmq = mkOption {
        description = "RabbitMQ configuration.";
        default = [];
        type = listOf (submodule (import ./host_port_pair.nix {
            inherit lib;
            name = "rabbitmq";
            defaultHost = "127.0.0.1";
            defaultPort = config.services.rabbitmq.port;
            options = {
              vhost = mkOption {
                default = "/sensu";
                description = "RabbitMQ vhost";
                type = str;
              };

              user = mkOption {
                default = "sensu";
                description = "RabbitMQ user";
                type = str;
              };

              password = mkOption {
                description = "RabbitMQ password";
                type = str;
              };

              heartbeat = mkOption {
                default = 30;
                description = "RabbitMQ heartbeat";
                type = int;
              };

              prefetch = mkOption {
                default = 50;
                description = "RabbitMQ prefetch";
                type = int;
              };

              ssl = mkOption {
                default = {};
                description = "RabbitMQ SSL options.";
                type = submodule {
                  options = {
                    cert_chain_file = mkOption {
                      default = "";
                      description = "Path to the cert chain file.";
                      type = str;
                    };

                    private_key_file = mkOption {
                      default = "";
                      description = "Path to the private key file.";
                      type = str;
                    };
                  };
                };
              };
            };
        }));
      };

      configureInfluxDb = mkOption {
        default = false;
        description = "Whether the database should be configured for Sensu on InfluxDB.";
        type = bool;
      };

      configureRabbitMq = mkOption {
        default = false;
        description = "Whether the vhost/user/permissions should be configured for Sensu on RabbitMQ.";
        type = bool;
      };

      api = mkOption {
        description = "API server configuration.";
        default = {};
        type = (submodule (import ./host_port_pair.nix {
          inherit lib;
          name = "api";
          defaultHost = "127.0.0.1";
          defaultPort = 4567;
          options = {
            bind = mkOption {
              type = str;
              default = "0.0.0.0";
              description = "The address that the API will bind to (listen on).";
            };
          };
        }));
      };

      programs = let
        programOption = name: default: mkOption {
          type = bool;
          description = "Enable support for ${name}.";
          inherit default;
        }; in mkOption {
        description = "Programs to enable for checks";
        default = {};
        type = submodule {
          options = {
            common  = programOption "common"  true;
            esx     = programOption "esx"     false;
            http    = programOption "http"    false;
            ipmi    = programOption "ipmi"    false;
            openvpn = programOption "openvpn" false;
            snmp    = programOption "snmp"    false;
          };
        };
      };

      checks = mkOption {
        type = with types; attrsOf (submodule (import ./checks.nix { inherit lib; }));
        default = {};
        description = "The checks configured.";
      };

      client = mkOption {
        description = "The client configuration.";
        default = {};
        type = submodule (import ./client.nix { inherit lib; });
      };

      dashboard = mkOption {
        description = "The Sensu dashboard.";
        default = {};
        type = submodule (import ./dashboard.nix { inherit cfg config lib; });
      };

      handlers = mkOption {
        type = with types; attrsOf (submodule (import ./handlers.nix { inherit lib; }));
        default = {};
        description = "The handlers available to Sensu.";
      };

      mutators = mkOption {
        type = with types; attrsOf (submodule (import ./mutators.nix { inherit lib; }));
        default = {};
        description = "The mutators available to Sensu.";
      };

      sites = mkOption {
        type = listOf (submodule (import ./sites.nix { inherit lib; }));
        description = "The sites configured.";
        default = [];
      };

      plugins = mkOption {
        type = attrs;
        description = "Plugin configuration.";
        default = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # Needed for being able to process UDP traffic
    boot.kernel.sysctl = lib.mkDefault {
      "net.core.rmem_max"     = 26214400;
      "net.core.rmem_default" = 26214400;
    };

    environment = let dir = "${lib.removePrefix "/etc/" baseDir}/conf.d"; in {
      etc = {
        checks = lib.mkIf roleIsServer {
          source = checkCfg;
          target = "${dir}/checks.json";
        };
        handlers = lib.mkIf roleIsServer {
          source = handlerCfg;
          target = "${dir}/handlers.json";
        };
        # influxdb_line_protocol = {
          # source = "${cfg.package}/bin/mutator-influxdb-line-protocol.rb";
          # target = "sensu/extensions/mutator-influxdb-line-protocol.rb";
        # };
        uchiwa = lib.mkIf roleIsServer {
          source = dashCfg;
          target = "sensu/uchiwa.json";
        };
        client = {
          source = clientCfg;
          target = "${dir}/client.json";
        };
        config = {
          source = sensuCfg;
          target = "sensu/config.json";
        };
      };

      systemPackages = with pkgs; [
        jq
        nmap
        tree
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openDefaultPorts ([]
      ++ lib.optional (cfg.client.socket != "127.0.0.1") cfg.client.socket.port
      ++ lib.optional roleIsServer                       cfg.api.port
      ++ lib.optional (cfg.dashboard.enable)             cfg.dashboard.port
    );

    services = let pcfg = cfg.dashboard.proxy; in {
      nginx = lib.mkIf pcfg.enable {
        enable = true;
        virtualHosts = {
          "${pcfg.name}" = rec {
            acmeFallbackHost = config.networking.hostName;
            enableSSL  = pcfg.enableSSL;
            enableACME = enableSSL;
            forceSSL   = enableSSL;
            extraConfig = let
              inherit (pcfg) enable path;
            in ''
              location ~ (${path}|/socket.io/) {
                proxy_pass http://localhost:${toString cfg.dashboard.port};
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host $host;

                rewrite ${path}(.*) /$1 break;
              }
            '';
          };
        };
      };

      rabbitmq = lib.mkIf (roleIsServer && transportIsRabbitMQ) {
        enable = true;
      };

      redis = lib.mkIf roleIsServer {
        enable = true;
        bind = "127.0.0.1";
      };

      sensu = {
        checks = {
          sensu-disk-root = {
            command = "check-disk-usage.rb -I /";
            subscribers = cfg.defaultServerSubscriptions ++ cfg.defaultClientSubscriptions;
          };

          sensu-disk-var = {
            command = "check-disk-usage.rb -I /var";
            subscribers = cfg.defaultServerSubscriptions ++ cfg.defaultClientSubscriptions;
          };

          sensu-influx-ping = {
            command = lib.concatStringsSep " " [
              "check-influxdb.rb"
              "--host ${cfg.influxdb.host}"
              "--port ${toString cfg.influxdb.port}"
            ];
            subscribers = cfg.defaultServerSubscriptions;
          };

          sensu-redis-mem = {
            command = lib.concatStringsSep " " [
              "check-redis-memory-percentage.rb"
              "--host ${cfg.redis.host}"
              "--port ${toString cfg.redis.port}"
              "--critmem 90"
              "--warnmem 70"
            ];
            subscribers = cfg.defaultServerSubscriptions;
          };
        };

        client.subscriptions = lib.mkIf cfg.addDefaultSubscriptions (
           if roleIsServer then cfg.defaultServerSubscriptions
                           else cfg.defaultClientSubscriptions
        );

        extensions = {
          influxdb =  {
            gem = "sensu-extensions-influxdb";
          };
          # history = {
            # gem = "sensu-extensions-history";
          # };
        };
      };
    };

    systemd = let
      runRabbitMq = (roleIsServer && transportIsRabbitMQ && cfg.configureRabbitMq);
    in {
      services = {
        sensu-api       = lib.mkIf roleIsServer         (sensuService "API"       (bin "api"));
        sensu-client    =                               (sensuService "Client"    (bin "client"));
        sensu-server    = lib.mkIf roleIsServer         (sensuService "Server"    (bin "server"));
        sensu-dashboard = lib.mkIf cfg.dashboard.enable (sensuService "Dashboard"
          "${pkgs.uchiwa}/bin/uchiwa -c ${baseDir}/uchiwa.json"
        );

        influxdb = lib.mkIf cfg.configureInfluxDb {
          wants = [ "influxdb-setup.service" ];
        };

        influxdb-setup = lib.mkIf cfg.configureInfluxDb (let
          idb = config.services.sensu.influxdb;
          service = [ "influxdb.service" ];
        in {
          description = "Configure InfluxDB database for Sensu";
          wants = service;
          after = service;
          script = ''
            ${lib.getBin pkgs.curl}/bin/curl -XPOST http://${idb.host}:${toString idb.port}/query --data-urlencode \
              "q=CREATE DATABASE ${idb.database}"
          '';
        });

        rabbitmq = lib.mkIf runRabbitMq {
          wants = [ "rabbitmq-setup.service" ];
        };

        rabbitmq-setup = lib.mkIf runRabbitMq (
        let
          rmq = builtins.head config.services.sensu.rabbitmq;
          service = [ "rabbitmq.service" ];
        in lib.mkIf transportIsRabbitMQ {
          description = "Configure RabbitMQ queue and user for Sensu";
          wants = service;
          after = service;
          script = ''
            export HOME=${config.services.rabbitmq.dataDir}
            export PATH=${lib.makeBinPath (with pkgs; [ coreutils gnused rabbitmq_server ])}:$PATH

            rabbitmqctl add_vhost ${rmq.vhost}
            rabbitmqctl add_user  ${rmq.user} '${rmq.password}'
            rabbitmqctl set_permissions -p ${rmq.vhost} ${rmq.user} ".*" ".*" ".*"

            # get rid of guest
            rabbitmqctl delete_user guest
          '';
        });
      };

      targets.sensu = {
        description = "Sensu Monitoring";
        wantedBy    = [ "multi-user.target" ];
      };
    };
  };
}
