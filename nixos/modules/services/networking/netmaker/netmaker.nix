{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.services.netmaker;

  envFile.generated.config = "${cfg.configDir}/env.generated";
  envFile.generated.secrets = "${cfg.secretsDir}/env.generated";
  envFile.user.config = "${cfg.configDir}/env";
  envFile.user.secrets = "${cfg.secretsDir}/env";
in
{
  meta.maintainers = with lib.maintainers; [ nazarewk ];

  options.services.netmaker = {
    enable = lib.mkEnableOption "Netmaker Server";

    domain = lib.mkOption {
      type = with lib.types; str;
      description = lib.mdDoc ''
        Base external domain to use for Netmaker deployment, used in:
        - `''${services.netmaker.api.domain}` (defaults to: `api.` prefix)
        - `''${services.netmaker.ui.domain}` (defaults to: `dashboard.` prefix)
        - `''${services.netmaker.mqtt.domain}` (defaults to: `broker.` prefix)
        - `''${services.netmaker.coredns.networks.domain}` (defaults to: `int.` prefix)
        - `ns.''${services.netmaker.domain}` - just a suggestion

        You might want to create following DNS records at your root DNS zone registrar before applying the module:

            api.<YOUR-DOMAIN>.         1       IN      A       <YOUR-SERVER-IP>
            broker.<YOUR-DOMAIN>.      1       IN      A       <YOUR-SERVER-IP>
            dashboard.<YOUR-DOMAIN>.   1       IN      A       <YOUR-SERVER-IP>
            ns.<YOUR-DOMAIN>.          1       IN      A       <YOUR-SERVER-IP>
            int.<YOUR-DOMAIN>.         1       IN      NS      ns.<YOUR-DOMAIN>
      '';
    };

    email = lib.mkOption {
      type = with lib.types; str;
      description = lib.mdDoc ''
        Email address to (currently) use for certificato registration.
      '';
    };

    coredns.networks.domain = lib.mkOption {
      type = with lib.types; str;
      default = "int.${config.services.netmaker.domain}";
      defaultText = lib.literalExpression ''"int.''${config.services.netmaker.domain}"'';
      description = lib.mdDoc ''
        The domain CoreDNS (by default) exposes Netmaker's networks under.
      '';
    };
    api.domain = lib.mkOption {
      type = with lib.types; str;
      default = "api.${config.services.netmaker.domain}";
      defaultText = lib.literalExpression ''"api.''${config.services.netmaker.domain}"'';
      description = lib.mdDoc ''
        The domain Netmaker Server's API is exposed on.
      '';
    };
    ui.domain = lib.mkOption {
      type = with lib.types; str;
      default = "dashboard.${config.services.netmaker.domain}";
      defaultText = lib.literalExpression ''"dashboard.''${config.services.netmaker.domain}"'';
      description = lib.mdDoc ''
        The domain Netmaker UI is exposed on.
      '';
    };
    mqtt.domain = lib.mkOption {
      type = with lib.types; str;
      default = "broker.${cfg.domain}";
      defaultText = lib.literalExpression ''"broker.''${config.services.netmaker.domain}"'';
      description = lib.mdDoc ''
        Domain the message queue is proxied through for external access.
      '';
    };

    package = lib.mkOption {
      type = with lib.types; package;
      default = if cfg.installType == "ce" then pkgs.netmaker else pkgs.netmaker-pro;
      defaultText = lib.literalExpression ''if cfg.installType == "ce" then pkgs.netmaker else pkgs.netmaker-pro'';
      description = lib.mdDoc ''
        Package providing `netmaker` binary.
      '';
    };

    nmctl.package = lib.mkOption {
      type = with lib.types; package;
      default = pkgs.nmctl;
      defaultText = lib.literalExpression ''pkgs.nmctl'';
      description = lib.mdDoc ''
        Package providing `nmctl` binary.
      '';
    };

    internalListenAddress = lib.mkOption {
      type = with lib.types; str;
      default = "127.0.0.2";
      description = lib.mdDoc ''
        An address services will be listening on before being proxied
      '';
    };

    verbosity = lib.mkOption {
      type = with lib.types; enum [ 1 2 3 4 ];
      default = 1;
      description = lib.mdDoc ''
        Verbosity level of Netmaker Server logging.
      '';
    };

    telemetry = lib.mkEnableOption "sending telemetry to Netmaker developers";

    environment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      apply = envAttrs: pkgs.writeText "environment-env" (lib.trivial.pipe envAttrs [
        (lib.attrsets.mapAttrsToList (name: value: "${name}=${lib.strings.escapeShellArg value}"))
        (builtins.concatStringsSep "\n")
      ]);
      description = lib.mdDoc ''
        Additional environment variables to set on Netmaker Server
      '';
    };

    environmentFiles = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      description = lib.mdDoc ''
        Additional files holding environment variable definitions to set on Netmaker Server
      '';
    };

    config = lib.mkOption {
      type = with lib.types; anything;
      description = lib.mdDoc ''
        Content of Netmaker configuration file.

        see for more information:
        - https://github.com/gravitl/netmaker/blob/dc8f9b1bc74d262669bf96fab5f0e545f5906432/config/config.go
      '';
      apply = value: pkgs.writeText "netmaker-config.json" (builtins.toJSON value);
    };

    installType = lib.mkOption {
      type = with lib.types; enum [
        "ce"
        "pro"
      ];
      default = "ce";
      description = lib.mdDoc ''
        Type of the installation: `ce` for Community and `pro` for Professional.

        `pro` requires additional configuration not covered by the module, for reference see the [code search](https://github.com/search?q=repo%3Agravitl%2Fnetmaker+%22%24INSTALL_TYPE%22&type=code)
      '';
    };

    dataDir = lib.mkOption {
      type = with lib.types; path;
      default = "/var/lib/netmaker";
      description = lib.mdDoc ''
        Netmaker data directory, currently simply a working directory the server is running in.
        It contains following known directories and files:
        - `data/netmaker.db` - sqlite database file
        - `data/netmaker.log.YYYY-MM-DD` - Netmaker server log files
        - `config/dnsconfig/netmaker.hosts` - `/etc/hosts` formatted file dynamically updated by Netmaker
        - `config/dnsconfig/Corefile` - generated by Netmaker, but not used in this module

        Current list of files can be found in [this GitHub search](https://github.com/search?q=repo%3Agravitl%2Fnetmaker+%22os.Getwd%28%29%22&type=code)
      '';
    };

    configDir = lib.mkOption {
      type = with lib.types; path;
      default = "/etc/netmaker";
      description = lib.mdDoc ''
        A configuration directory to (currently) put NixOS module related configuration files in.

        Following configuration files are used by default:
        - `''${config.services.netmaker.configDir}/env` - user editable environment variables
        - `''${config.services.netmaker.configDir}/env.generated` - generated environment variables
      '';
    };

    secretsDir = lib.mkOption {
      type = with lib.types; path;
      default = "${config.services.netmaker.configDir}/secrets";
      defaultText = lib.literalExpression ''"''${config.services.netmaker.configDir}/secrets"'';
      description = lib.mdDoc ''
        A directory to read sensitive configuration (secrets) from.

        Following secrets files are used by default:
        - `''${config.services.netmaker.secretsDir}/env` - user editable sensitive environment variables
        - `''${config.services.netmaker.secretsDir}/env.generated` - generated sensitive environment variables
        - `''${config.services.netmaker.mqtt.passwordFile}` - generated message queue password file

        Example things you can do with those:
        - configure OAuth
      '';
    };

    jwtValiditySeconds = lib.mkOption {
      type = with lib.types; ints.u32;
      default = 24 * 60 * 60;
      description = lib.mdDoc ''
        Validity period of issued JWT authentication tokens in seconds;
      '';
    };

    cors.maxAge = lib.mkOption {
      type = with lib.types; int;
      default = 5 * 60;
      description = lib.mdDoc ''
        Maximum age of CORS preflight requests issued to Netmaker Server.

        see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Max-Age
      '';
    };

    api.internal = lib.mkOption {
      type = lib.types.submodule (args: {
        options = {
          host = lib.mkOption {
            type = with lib.types; str;
            default = config.services.netmaker.internalListenAddress;
            defaultText = lib.literalExpression ''config.services.netmaker.internalListenAddress'';
            description = lib.mdDoc ''
              The host Netmaker Server's API is listening on internally.
            '';
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 8081;
            description = lib.mdDoc ''
              The port Netmaker Server's API is listening on internally.
            '';
          };
          addr = lib.mkOption {
            type = with lib.types; str;
            internal = true;
            readOnly = true;
            default = with args.config; "${host}:${builtins.toString port}";
          };
        };
      });
      default = { };
      description = lib.mdDoc ''
        Specification of internally reachable listener for Netmaker Server's API.
      '';
    };

    ui.enable = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = lib.mdDoc ''
        Should Netmaker (web) UI/Dashboard be enabled?
        According to official documentation Netmaker is usable without an UI through CLI tools.
      '';
    };
    ui.package = lib.mkOption {
      type = with lib.types; package;
      default = pkgs.netmaker-ui;
      defaultText = lib.literalExpression ''pkgs.netmaker-ui'';
      description = lib.mdDoc ''
        A package holding Netmaker UI assets at `''${out}/var/www`
      '';
    };
    ui.saas.amuiUrl = lib.mkOption {
      type = with lib.types; str;
      default = "https://account.staging.netmaker.io";
      description = lib.mdDoc ''
        A piece configuration related to SaaS build of the UI.
      '';
    };
    ui.saas.intercomAppID = lib.mkOption {
      type = with lib.types; str;
      default = "";
      description = lib.mdDoc ''
        A piece configuration related to SaaS build of the UI.
      '';
    };

    firewall.ports = {
      networks.start = lib.mkOption {
        type = with lib.types; port;
        internal = true;
        readOnly = true;
        default = 51821;
      };
      networks.capacity = lib.mkOption {
        type = with lib.types; port;
        default = 10;

        description = lib.mdDoc ''
          Number of Netmaker networks to open up firewall for:
          > Netmaker needs one port per network, starting with 51821,
          > so open up a range depending on the number of networks
          > you plan on having. For instance, 51821-51830.
        '';
      };
    };

    webserver.type = lib.mkOption {
      type = with lib.types; enum [
        "caddy"
        "none"
      ];
      default = "caddy";
      description = lib.mdDoc ''
        A webserver to expose Netmaker Server components through:
        - Netmaker API
        - Netmaker UI
        - MQTT broker via websocket

        The module currently supports only Caddy or nothing at all (configured externally).
      '';
    };

    webserver.openFirewall = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = lib.mdDoc ''
        Open firewall on ports 80/443 and add required permissions.
      '';
    };

    db.type = lib.mkOption {
      type = with lib.types; enum [
        "sqlite"
        "rqlite"
        "postgres"
      ];
      default = "sqlite";
      description = lib.mdDoc ''
        Type of database to use for Netmaker.
        Only `sqlite` is supported without additional configuration.

        See [the source code](https://github.com/gravitl/netmaker/blob/fa9372ea56ef6e194dd57bf987bd86ac6d37e30f/database/database.go#L94-L105)
        for list of backends supported.
      '';
    };

    coredns.internal.port = lib.mkOption {
      type = lib.types.port;
      internal = true;
      readOnly = true;
      default = 53;
    };
    coredns.defaults.forwards = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "8.8.8.8"
        "8.8.4.4"
      ];
      description = lib.mdDoc ''
        Defines upstream DNS servers to use in default CoreDNS configuration.
      '';
    };
    coredns.hostsPath = lib.mkOption {
      type = with lib.types; str;
      readOnly = true;
      default = "${config.services.netmaker.dataDir}/config/dnsconfig/netmaker.hosts";
      defaultText = lib.literalExpression ''"''${config.services.netmaker.dataDir}/config/dnsconfig/netmaker.hosts"'';
      description = lib.mdDoc ''
        Path to Netmaker managed hosts file.
      '';
    };

    coredns.networksDomain = lib.mkOption {
      type = with lib.types; str;
      readOnly = true;
      default = "int.${config.services.netmaker.domain}";
      defaultText = lib.literalExpression ''"int.''${config.services.netmaker.domain}"'';
      description = lib.mdDoc ''
        Primary domain to expose Netmaker's networks under.
        See `config.services.netmaker.coredns` for more detailed information.
      '';
    };
    coredns.exposeAt = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ config.services.netmaker.coredns.networksDomain ];
      defaultText = lib.literalExpression ''[ config.services.netmaker.coredns.networksDomain ]'';
      description = lib.mdDoc ''
        Parent domains under which the CoreDNS will serve Netmaker generated hosts.
        Served domains do not need to be related to the primary netmaker domain.

        as an example with following state:
        - base domain: `<YOUR-DOMAIN>`
        - network: `priv`
        - hosts: `host1` `host2`
        - `coredns.exposeAt` with default value
        CoreDNS will serve to following queries:
        - `host1.priv.`
        - `host2.priv.`
        - `host1.priv.int.<YOUR-DOMAIN>.`
        - `host2.priv.int.<YOUR-DOMAIN>.`

        Wiring this up with following 2 records as your DNS root zone
        will make the latter 2 resolvable publicly resolvable:
            ns.<YOUR-DOMAIN>.          1       IN      A       <YOUR-SERVER-IP>
            int.<YOUR-DOMAIN>.         1       IN      NS      ns.<YOUR-DOMAIN>
      '';
      apply = value: lib.pipe value [
        (builtins.map (domain: lib.pipe domain [
          (lib.strings.removePrefix ".")
          (lib.strings.removeSuffix ".")
          (stripped: "rewrite name suffix .${stripped}. . answer auto")
        ]))
        (builtins.concatStringsSep "\n")
      ];
    };

    coredns.defaults.reloadInterval = lib.mkOption {
      type = with lib.types; str;
      default = "5s";
      description = lib.mdDoc ''
        Defines how often CoreDNS reloads Netmaker's hosts file.
      '';
    };

    coredns.defaults.config = lib.mkOption {
      type = with lib.types; str;
      default = ''
        .:${builtins.toString config.services.netmaker.coredns.internal.port} {
          import netmaker
          ${lib.optionalString (config.services.netmaker.coredns.defaults.forwards != [])
              "forward . ${builtins.concatStringsSep " " config.services.netmaker.coredns.defaults.forwards}"}
          ${lib.optionalString config.services.netmaker.coredns.debug "log"}
        }
      '';
      defaultText = lib.literalExpression ''
        '''
          .:''${builtins.toString config.services.netmaker.coredns.internal.port} {
            import netmaker
            ''${lib.optionalString (config.services.netmaker.coredns.defaults.forwards != [])
                "forward . ''${builtins.concatStringsSep " " config.services.netmaker.coredns.defaults.forwards}"}
            ''${lib.optionalString config.services.netmaker.coredns.debug "log"}
          }
        '''
      '';
      description = lib.mdDoc ''
        Default CoreDNS Corefile content to use with Netmaker.
        You can set it to `""` and simlpy include `import netmaker` where approriate yourself,
        because part of configuration required by Netmaker is managed separately as a snippet.
      '';
      example = lib.literalExpression ''""'';
    };

    mqtt.type = lib.mkOption {
      type = with lib.types; enum [
        "mosquitto"
        "emqx"
      ];
      default = "mosquitto";
      description = lib.mdDoc ''
        Type of message queue to use for Netmaker.

        `emqx` [is not packaged in nixpkgs yet](https://github.com/NixOS/nixpkgs/issues/266659), therefore requires
        configuring external service yourself.
      '';
    };
    mqtt.internal = lib.mkOption {
      type = lib.types.submodule (args: {
        options = {
          host = lib.mkOption {
            type = with lib.types; str;
            default = config.services.netmaker.internalListenAddress;
            defaultText = lib.literalExpression ''config.services.netmaker.internalListenAddress'';
            description = lib.mdDoc ''
              The host message queue is listening on internally.
            '';
          };
          port = lib.mkOption {
            type = lib.types.port;
            description = lib.mdDoc ''
              The port message queue is listening on internally.
            '';
            default = 9001;
          };
          addr = lib.mkOption {
            type = with lib.types; str;
            internal = true;
            readOnly = true;
            default = with args.config; "${host}:${builtins.toString port}";
          };
        };
      });
      default = { };
      description = lib.mdDoc ''
        Specification of internally reachable listener for the message queue.
      '';
    };
    mqtt.username = lib.mkOption {
      type = with lib.types; str;
      default = "netmaker";
      description = lib.mdDoc ''
        Username credential for the message queue.
      '';
    };
    mqtt.passwordFile = lib.mkOption {
      type = with lib.types; path;
      default = "${config.services.netmaker.secretsDir}/MQ_PASSWORD";
      defaultText = lib.literalExpression ''"''${config.services.netmaker.secretsDir}/MQ_PASSWORD"'';
      description = lib.mdDoc ''
        Location of the file holding password for the message queue (auto-generated by init script).
      '';
    };
    mqtt.acl.restricted = lib.mkEnableOption "MQTT instance access restrictions for `netmaker` user";
    mqtt.acl.extraRules = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = lib.mdDoc ''
        Extends list of ACL rules for `netmaker`.
      '';
      example = lib.literalExpression ''
        [
          "readwrite some/missing/topic"
        ]
      '';
    };

    debug = lib.mkEnableOption "configuring everything with the most verbose log level";
    debugTools = lib.mkOption {
      type = with lib.types; bool;
      default = config.services.netmaker.debug;
      defaultText = lib.literalExpression ''config.services.netmaker.debug'';
      description = lib.mdDoc ''
        Install additional debugging tools:
        - `mqttui`
        - `netmaker-mqttui` script
      '';
    };
    coredns.debug = lib.mkOption {
      type = with lib.types; bool;
      default = config.services.netmaker.debug;
      defaultText = lib.literalExpression ''config.services.netmaker.debug'';
      description = lib.mdDoc ''
        Run CoreDNS in a full debug mode.
      '';
    };
    webserver.debug = lib.mkOption {
      type = with lib.types; bool;
      default = config.services.netmaker.debug;
      defaultText = lib.literalExpression ''config.services.netmaker.debug'';
      description = lib.mdDoc ''
        Run webserver in a full debug mode.
      '';
    };
    mqtt.debug = lib.mkOption {
      type = with lib.types; bool;
      default = config.services.netmaker.debug;
      defaultText = lib.literalExpression ''config.services.netmaker.debug'';
      description = lib.mdDoc ''
        Run message queue in a full debug mode.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.nmctl.package ];

      networking.firewall.allowedUDPPortRanges = with cfg.firewall.ports;  [{
        from = networks.start;
        to = networks.start + networks.capacity - 1;
      }];
    }
    {
      systemd.tmpfiles.rules = [
        "d ${cfg.secretsDir} 1700 root root"
        "f ${envFile.generated.config} 1644 root root"
        "f ${envFile.generated.secrets} 1600 root root"
        "f ${envFile.user.config} 1644 root root"
        "f ${envFile.user.secrets} 1600 root root"
      ];

      services.netmaker.environmentFiles = [
        envFile.generated.config
        envFile.generated.secrets
        envFile.user.config
        envFile.user.secrets
        (lib.mkAfter cfg.environment)
      ];

      services.netmaker.config = {
        server = {
          apiconn = "${cfg.api.domain}:443";
          apihost = cfg.api.domain;
          apilistenaddress = cfg.api.internal.host;
          apiport = builtins.toString cfg.api.internal.port;
          broker = "wss://${cfg.mqtt.domain}";
          brokertype = cfg.mqtt.type;
          database = cfg.db.type;
          frontendurl = "https://${cfg.ui.domain}";
          jwt_validity_seconds = cfg.jwtValiditySeconds;
          mqusername = cfg.mqtt.username;
          server = cfg.domain;
          serverbrokerendpoint = "ws://${cfg.mqtt.internal.addr}";
          telemetry = if cfg.telemetry then "on" else "off";
          verbosity = cfg.verbosity;
          # don't set to anything, see https://github.com/nazarewk/netmaker/blob/9ca6b44228847d246dd5617b73f69ec26778f396/servercfg/serverconf.go#L215-L223
          corednsaddr = "";
        };
      };

      systemd.services.netmaker-configure = {
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          inherit (config.systemd.services.netmaker.serviceConfig) EnvironmentFile;
        };
        environment = {
          MQ_PASSWORD_FILE = cfg.mqtt.passwordFile;
          SECRETS_FILE = envFile.generated.secrets;
          ENV_FILE = envFile.generated.config;
        };
        script = lib.getExe (pkgs.writeShellApplication {
          name = "netmaker-generate-config";
          runtimeInputs = with pkgs; [
            coreutils
            gawk
            gnugrep
            gnused
          ];
          text = builtins.readFile ./netmaker-generate-config.sh;
        });
      };

      # based on https://github.com/gravitl/netclient/blob/b9ea9c9841f01297955b03c2b5bbf4b5139aa40c/daemon/systemd_linux.go#L14-L30
      systemd.services.netmaker = {
        description = "Netmaker Server daemon";
        after = [ "network-online.target" "netmaker-configure.service" ];
        wants = [ "network-online.target" ];
        requires = [ "netmaker-configure.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          EnvironmentFile = cfg.environmentFiles;
          WorkingDirectory = cfg.dataDir;
          Restart = "on-failure";
          RestartSec = "15s";

          ExecStart = "${lib.getExe cfg.package} -c ${cfg.config}";
          ExecStartPost = pkgs.writeShellScript "configure-nmctl" ''
            export HOME=/root
            ${lib.getExe cfg.nmctl.package} context set default \
              --endpoint="https://${cfg.api.domain}" \
              --master_key="$MASTER_KEY"
          '';
        };
      };
    }
    {
      # CoreDNS related config
      services.coredns.enable = true;
      # defines a snippet that can be integrated without clashes, see https://coredns.io/manual/toc/#reusable-snippets
      services.coredns.config = ''
        (netmaker) {
          ${cfg.coredns.exposeAt}
          hosts ${cfg.coredns.hostsPath} {
            ttl 3600 # default
            reload 5s
            fallthrough
          }
        }
        ${cfg.coredns.defaults.config}
      '';
      networking.firewall = with cfg.firewall.ports; {
        allowedTCPPorts = [ cfg.coredns.internal.port ];
        allowedUDPPorts = [ cfg.coredns.internal.port ];
      };
    }
    (lib.mkIf (cfg.debugTools) {
      environment.systemPackages = with pkgs; [
        mqttui
        (pkgs.writeShellApplication {
          name = "netmaker-mqttui";
          runtimeInputs = with pkgs; [ mqttui jq ];
          text = ''
            get() {
              test -n "''${info:-}" || info="$(nmctl server info -o json | jq -c)"
              jq -r "$@" <<<"$info"
            }

            export MQTTUI_PASSWORD="''${MQTTUI_PASSWORD:-"$(get '.MQPassword')"}"
            export MQTTUI_USERNAME="''${MQTTUI_USERNAME:-"$(get '.MQUserName')"}"
            export MQTTUI_BROKER="''${MQTTUI_BROKER:-"$(get '.Broker')"}"
            exec mqttui "$@"
          '';
        })
      ];
    })
    (lib.mkIf (cfg.webserver.type == "caddy") {
      services.caddy.enable = true;
      networking.firewall.allowedTCPPorts = lib.optionals cfg.webserver.openFirewall [ 80 443 ];
      systemd.services.caddy.serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

      systemd.services.netmaker = {
        after = [ "caddy.service" ];
        requires = [ "caddy.service" ];
      };

      services.caddy.virtualHosts."https://${cfg.api.domain}".extraConfig = ''
        ${lib.optionalString (cfg.email != "") "tls ${cfg.email}"}
        header {
          Access-Control-Allow-Origin *
          Access-Control-Max-Age ${builtins.toString cfg.cors.maxAge}
          -Server
        }
        reverse_proxy http://${cfg.api.internal.addr}
      '';
    })
    (lib.mkIf (cfg.webserver.type == "caddy" && cfg.ui.enable) {
      # see https://github.com/gravitl/netmaker/blob/630c95c48b43ac8b0cdff1c3de13339c8b322889/docker/Caddyfile#L1-L20
      services.caddy.virtualHosts."https://${cfg.ui.domain}".extraConfig = ''
        ${lib.optionalString (cfg.email != "") "tls ${cfg.email}"}
        header {
          Access-Control-Allow-Origin https://${cfg.ui.domain}
          Access-Control-Max-Age ${builtins.toString cfg.cors.maxAge}
          Strict-Transport-Security "max-age=31536000;"
          X-XSS-Protection "1; mode=block"
          X-Frame-Options "SAMEORIGIN"
          X-Robots-Tag "none"
          -Server
        }

        handle /nmui-config.js {
          header Content-Type text/javascript
          respond <<EOF
          window.NMUI_AMUI_URL='${cfg.ui.saas.amuiUrl}';
          window.NMUI_INTERCOM_APP_ID='${cfg.ui.saas.intercomAppID}';
          window.NMUI_BACKEND_URL='https://${cfg.api.domain}';
          EOF
        }

        handle {
          # see https://github.com/gravitl/netmaker-ui-2/blob/b305a96fc19160346f7cd59439d4625f262aaedf/nginx.conf#L7-L7
          try_files {path} {path}/ /index.html
          root * ${cfg.ui.package}/var/www
          file_server
        }
      '';
    })
    (lib.mkIf (cfg.mqtt.type == "mosquitto" && cfg.webserver.type == "caddy") {
      # see https://www.reddit.com/r/selfhosted/comments/14wqwa4/comment/jrp07gq/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      services.caddy.virtualHosts."https://${cfg.mqtt.domain}".extraConfig = ''
        ${lib.optionalString (cfg.email != "") "tls ${cfg.email}"}
        reverse_proxy http://${cfg.mqtt.internal.addr} {
          stream_timeout 6h
          stream_close_delay 1m
        }
      '';
    })
    (lib.mkIf (cfg.mqtt.type == "mosquitto") {
      systemd.services.mosquitto = {
        after = [ "netmaker-configure.service" ];
        requires = [ "netmaker-configure.service" ];
      };
      systemd.services.netmaker = {
        after = [ "mosquitto.service" ];
        requires = [ "mosquitto.service" ];
      };

      services.mosquitto.enable = true;
      services.mosquitto.listeners = [{
        address = cfg.mqtt.internal.host;
        port = cfg.mqtt.internal.port;
        users."${cfg.mqtt.username}" = {
          passwordFile = cfg.mqtt.passwordFile;
          acl =
            if !cfg.mqtt.acl.restricted then [
              "readwrite #"
            ] else [
              # note: current set of topics can be found using https://github.com/search?q=%28+repo%3Agravitl%2Fnetclient+OR+repo%3Agravitl%2Fnetmaker+%29+AND+%28%22+publish%28%22+OR+%22client.Publish%28%22+OR+%22client.Subscribe%28%22%29&type=code
              "readwrite host/serverupdate/+/#"
              "readwrite host/update/+/+"
              "readwrite metrics/+/#"
              "readwrite metrics_exporter"
              "readwrite node/update/+/+"
              "readwrite peers/host/+/+"
              "readwrite signal/+/#"
              "readwrite update/+/#"
            ] ++ cfg.mqtt.acl.extraRules;
        };
        settings.allow_anonymous = false;
        settings.protocol = "websockets";
      }];
    })
    (lib.mkIf (cfg.mqtt.type == "mosquitto" && cfg.mqtt.debug) {
      services.mosquitto.logType = [ "all" ];
    })
    (lib.mkIf (cfg.webserver.type == "caddy" && cfg.webserver.debug) {
      services.caddy.logFormat = "level DEBUG";
    })
  ]);
}
