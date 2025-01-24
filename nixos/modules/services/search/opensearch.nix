{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.opensearch;

  settingsFormat = pkgs.formats.yaml { };

  configDir = cfg.dataDir + "/config";

  usingDefaultDataDir = cfg.dataDir == "/var/lib/opensearch";
  usingDefaultUserAndGroup = cfg.user == "opensearch" && cfg.group == "opensearch";

  opensearchYml = settingsFormat.generate "opensearch.yml" cfg.settings;

  loggingConfigFilename = "log4j2.properties";
  loggingConfigFile = pkgs.writeTextFile {
    name = loggingConfigFilename;
    text = cfg.logging;
  };
in
{

  options.services.opensearch = {
    enable = mkEnableOption "OpenSearch";

    package = lib.mkPackageOption pkgs "OpenSearch" {
      default = [ "opensearch" ];
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options."network.host" = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = ''
            Which port this service should listen on.
          '';
        };

        options."cluster.name" = lib.mkOption {
          type = lib.types.str;
          default = "opensearch";
          description = ''
            The name of the cluster.
          '';
        };

        options."discovery.type" = lib.mkOption {
          type = lib.types.str;
          default = "single-node";
          description = ''
            The type of discovery to use.
          '';
        };

        options."http.port" = lib.mkOption {
          type = lib.types.port;
          default = 9200;
          description = ''
            The port to listen on for HTTP traffic.
          '';
        };

        options."transport.port" = lib.mkOption {
          type = lib.types.port;
          default = 9300;
          description = ''
            The port to listen on for transport traffic.
          '';
        };

        options."plugins.security.disabled" = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to enable the security plugin,
            `plugins.security.ssl.transport.keystore_filepath` or
            `plugins.security.ssl.transport.server.pemcert_filepath` and
            `plugins.security.ssl.transport.client.pemcert_filepath`
            must be set for this plugin to be enabled.
          '';
        };
      };

      default = { };

      description = ''
        OpenSearch configuration.
      '';
    };

    logging = lib.mkOption {
      description = "opensearch logging configuration.";

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
      apply = converge (removeSuffix "/");
      description = ''
        Data directory for OpenSearch. If you change this, you need to
        manually create the directory. You also need to create the
        `opensearch` user and group, or change
        [](#opt-services.opensearch.user) and
        [](#opt-services.opensearch.group) to existing ones with
        access to the directory.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "opensearch";
      description = ''
        The user OpenSearch runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "opensearch";
      description = ''
        The group OpenSearch runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    extraCmdLineOptions = lib.mkOption {
      description = "Extra command line options for the OpenSearch launcher.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
    };

    extraJavaOptions = lib.mkOption {
      description = "Extra command line options for Java.";
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [ "-Djava.net.preferIPv4Stack=true" ];
    };

    restartIfChanged = lib.mkOption {
      type = lib.types.bool;
      description = ''
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
      serviceConfig =
        {
          ExecStartPre =
            let
              startPreFullPrivileges =
                ''
                  set -o errexit -o pipefail -o nounset -o errtrace
                  shopt -s inherit_errexit
                ''
                + (optionalString (!config.boot.isContainer) ''
                  # Only set vm.max_map_count if lower than ES required minimum
                  # This avoids conflict if configured via boot.kernel.sysctl
                  if [ $(${pkgs.procps}/bin/sysctl -n vm.max_map_count) -lt 262144 ]; then
                    ${pkgs.procps}/bin/sysctl -w vm.max_map_count=262144
                  fi
                '');
              startPreUnprivileged = ''
                set -o errexit -o pipefail -o nounset -o errtrace
                shopt -s inherit_errexit

                # Install plugins

                # remove plugins directory if it is empty.
                if [[ -d ${cfg.dataDir}/plugins && -z "$(ls -A ${cfg.dataDir}/plugins)" ]]; then
                  rm -r "${cfg.dataDir}/plugins"
                fi

                ln -sfT "${cfg.package}/plugins" "${cfg.dataDir}/plugins"
                ln -sfT ${cfg.package}/lib ${cfg.dataDir}/lib
                ln -sfT ${cfg.package}/modules ${cfg.dataDir}/modules

                # opensearch needs to create the opensearch.keystore in the config directory
                # so this directory needs to be writable.
                mkdir -p ${configDir}
                chmod 0700 ${configDir}

                # Note that we copy config files from the nix store instead of symbolically linking them
                # because otherwise X-Pack Security will raise the following exception:
                # java.security.AccessControlException:
                # access denied ("java.io.FilePermission" "/var/lib/opensearch/config/opensearch.yml" "read")

                rm -f ${configDir}/opensearch.yml
                cp ${opensearchYml} ${configDir}/opensearch.yml

                # Make sure the logging configuration for old OpenSearch versions is removed:
                rm -f "${configDir}/logging.yml"
                rm -f ${configDir}/${loggingConfigFilename}
                cp ${loggingConfigFile} ${configDir}/${loggingConfigFilename}
                mkdir -p ${configDir}/scripts

                rm -f ${configDir}/jvm.options
                cp ${cfg.package}/config/jvm.options ${configDir}/jvm.options

                # redirect jvm logs to the data directory
                mkdir -p ${cfg.dataDir}/logs
                chmod 0700 ${cfg.dataDir}/logs
                sed -e '#logs/gc.log#${cfg.dataDir}/logs/gc.log#' -i ${configDir}/jvm.options
              '';
            in
            [
              "+${pkgs.writeShellScript "opensearch-start-pre-full-privileges" startPreFullPrivileges}"
              "${pkgs.writeShellScript "opensearch-start-pre-unprivileged" startPreUnprivileged}"
            ];
          ExecStartPost = pkgs.writeShellScript "opensearch-start-post" ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            # Make sure opensearch is up and running before dependents
            # are started
            while ! ${pkgs.curl}/bin/curl -sS -f http://${cfg.settings."network.host"}:${
              toString cfg.settings."http.port"
            } 2>/dev/null; do
              sleep 1
            done
          '';
          ExecStart = "${cfg.package}/bin/opensearch ${toString cfg.extraCmdLineOptions}";
          User = cfg.user;
          Group = cfg.group;
          LimitNOFILE = "1024000";
          Restart = "always";
          TimeoutStartSec = "infinity";
          DynamicUser = usingDefaultUserAndGroup && usingDefaultDataDir;
        }
        // (optionalAttrs (usingDefaultDataDir) {
          StateDirectory = "opensearch";
          StateDirectoryMode = "0700";
        });
    };

    environment.systemPackages = [ cfg.package ];
  };
}
