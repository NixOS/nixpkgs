{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opensearch;

  settingsFormat = pkgs.formats.yaml {};

  configDir = cfg.dataDir + "/config";

  opensearchYml = settingsFormat.generate "opensearch.yml" cfg.settings;

  loggingConfigFilename = "log4j2.properties";
  loggingConfigFile = pkgs.writeTextFile {
    name = loggingConfigFilename;
    text = cfg.logging;
  };
in
{

  options.services.opensearch = {
    enable = mkEnableOption (lib.mdDoc "Whether to enable OpenSearch.");

    package = lib.mkPackageOptionMD pkgs "OpenSearch package to use." {
      default = [ "opensearch" ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options."network.host" = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = lib.mdDoc ''
            Which port this service should listen on.
          '';
        };

        options."cluster.name" = lib.mkOption {
          type = lib.types.str;
          default = "opensearch";
          description = lib.mdDoc ''
            The name of the cluster.
          '';
        };

        options."discovery.type" = lib.mkOption {
          type = lib.types.str;
          default = "single-node";
          description = lib.mdDoc ''
            The type of discovery to use.
          '';
        };

        options."http.port" = lib.mkOption {
          type = lib.types.port;
          default = 9200;
          description = lib.mdDoc ''
            The port to listen on for HTTP traffic.
          '';
        };

        options."transport.port" = lib.mkOption {
          type = lib.types.port;
          default = 9300;
          description = lib.mdDoc ''
            The port to listen on for transport traffic.
          '';
        };
      };

      default = {};

      description = lib.mdDoc ''
        OpenSearch configuration.
      '';
    };

    logging = lib.mkOption {
      description = lib.mdDoc "opensearch logging configuration.";

      default = ''
        logger.action.name = org.opensearch.action
        logger.action.level = info

        appender.console.type = Console
        appender.console.name = console
        appender.console.layout.type = PatternLayout
        appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n

        rootLogger.level = info
        rootLogger.appenderRef.console.ref = console
      '';
      type = types.str;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/opensearch";
      description = lib.mdDoc ''
        Data directory for opensearch.
      '';
    };

    extraCmdLineOptions = lib.mkOption {
      description = lib.mdDoc "Extra command line options for the opensearch launcher.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
    };

    extraJavaOptions = lib.mkOption {
      description = lib.mdDoc "Extra command line options for Java.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [ "-Djava.net.preferIPv4Stack=true" ];
    };

    restartIfChanged = lib.mkOption {
      type = lib.types.bool;
      description = lib.mdDoc ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on a server or cluster.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = true;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.opensearch = {
      description = "OpenSearch Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.inetutils ];
      inherit (cfg) restartIfChanged;
      environment = {
        OPENSEARCH_HOME = cfg.dataDir;
        OPENSEARCH_JAVA_OPTS = toString cfg.extraJavaOptions;
        OPENSEARCH_PATH_CONF = configDir;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/opensearch ${toString cfg.extraCmdLineOptions}";
        User = "opensearch";
        Group = "opensearch";
        StateDirectory = cfg.dataDir;
        StateDirectoryMode = "0700";
        PermissionsStartOnly = true;
        LimitNOFILE = "1024000";
        Restart = "always";
        TimeoutStartSec = "infinity";
      };
      preStart = optionalString (!config.boot.isContainer) ''
        # Only set vm.max_map_count if lower than ES required minimum
        # This avoids conflict if configured via boot.kernel.sysctl
        if [ $(${pkgs.procps}/bin/sysctl -n vm.max_map_count) -lt 262144 ]; then
          ${pkgs.procps}/bin/sysctl -w vm.max_map_count=262144
        fi
     '' + ''
        mkdir -m 0700 -p ${cfg.dataDir}

        # Install plugins
        ln -sfT ${cfg.package}/lib ${cfg.dataDir}/lib
        ln -sfT ${cfg.package}/modules ${cfg.dataDir}/modules

        # opensearch needs to create the opensearch.keystore in the config directory
        # so this directory needs to be writable.
        mkdir -m 0700 -p ${configDir}

        # Note that we copy config files from the nix store instead of symbolically linking them
        # because otherwise X-Pack Security will raise the following exception:
        # java.security.AccessControlException:
        # access denied ("java.io.FilePermission" "/var/lib/opensearch/config/opensearch.yml" "read")

        cp ${opensearchYml} ${configDir}/opensearch.yml
        # Make sure the logging configuration for old opensearch versions is removed:
        rm -f "${configDir}/logging.yml"
        cp ${loggingConfigFile} ${configDir}/${loggingConfigFilename}
        mkdir -p ${configDir}/scripts
        cp ${cfg.package}/config/jvm.options ${configDir}/jvm.options
        # redirect jvm logs to the data directory
        mkdir -m 0700 -p ${cfg.dataDir}/logs
        sed -e '#logs/gc.log#${cfg.dataDir}/logs/gc.log#' -i ${configDir}/jvm.options \

        if [ "$(id -u)" = 0 ]; then chown -R opensearch:opensearch ${cfg.dataDir}; fi
      '';
      postStart = ''
        # Make sure opensearch is up and running before dependents
        # are started
        while ! ${pkgs.curl}/bin/curl -sS -f http://${cfg.settings."network.host"}:${toString cfg.settings."http.port"} 2>/dev/null; do
          sleep 1
        done
      '';
    };

    environment.systemPackages = [ cfg.package ];

    users = {
      groups.opensearch = {};
      users.opensearch = {
        description = "OpenSearch daemon user";
        home = cfg.dataDir;
        group = "opensearch";
        isSystemUser = true;
      };
    };
  };
}
