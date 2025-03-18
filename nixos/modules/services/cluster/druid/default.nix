{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.druid;
  inherit (lib)
    concatStrings
    concatStringsSep
    mapAttrsToList
    concatMap
    attrByPath
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    types
    mkPackageOption
    ;

  druidServiceOption = serviceName: {
    enable = mkEnableOption serviceName;

    restartIfChanged = mkOption {
      type = types.bool;
      description = ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on clusters running critical applications.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = false;
    };

    config = mkOption {
      default = { };
      type = types.attrsOf types.anything;
      description = ''
        (key=value) Configuration to be written to runtime.properties of the druid ${serviceName}
        <https://druid.apache.org/docs/latest/configuration/index.html>
      '';
      example = {
        "druid.plainTextPort" = "8082";
        "druid.service" = "servicename";
      };
    };

    jdk = mkPackageOption pkgs "JDK" { default = [ "jdk17_headless" ]; };

    jvmArgs = mkOption {
      type = types.str;
      default = "";
      description = "Arguments to pass to the JVM";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall ports for ${serviceName}.";
    };

    internalConfig = mkOption {
      default = { };
      type = types.attrsOf types.anything;
      internal = true;
      description = "Internal Option to add to runtime.properties for ${serviceName}.";
    };
  };

  druidServiceConfig =
    {
      name,
      serviceOptions ? cfg."${name}",
      allowedTCPPorts ? [ ],
      tmpDirs ? [ ],
      extraConfig ? { },
    }:
    (mkIf serviceOptions.enable (mkMerge [
      {
        systemd = {
          services."druid-${name}" = {
            after = [ "network.target" ];

            description = "Druid ${name}";

            wantedBy = [ "multi-user.target" ];

            inherit (serviceOptions) restartIfChanged;

            path = [
              cfg.package
              serviceOptions.jdk
            ];

            script =
              let
                cfgFile =
                  fileName: properties:
                  pkgs.writeTextDir fileName (
                    concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${toString v}") properties)
                  );

                commonConfigFile = cfgFile "common.runtime.properties" cfg.commonConfig;

                configFile = cfgFile "runtime.properties" (serviceOptions.config // serviceOptions.internalConfig);

                extraClassPath = concatStrings (map (path: ":" + path) cfg.extraClassPaths);

                extraConfDir = concatStrings (map (dir: ":" + dir + "/*") cfg.extraConfDirs);
              in
              ''
                run-java -Dlog4j.configurationFile=file:${cfg.log4j} \
                  -Ddruid.extensions.directory=${cfg.package}/extensions \
                  -Ddruid.extensions.hadoopDependenciesDir=${cfg.package}/hadoop-dependencies \
                  -classpath  ${commonConfigFile}:${configFile}:${cfg.package}/lib/\*${extraClassPath}${extraConfDir} \
                  ${serviceOptions.jvmArgs} \
                  org.apache.druid.cli.Main server ${name}
              '';

            serviceConfig = {
              User = "druid";
              SyslogIdentifier = "druid-${name}";
              Restart = "always";
            };
          };

          tmpfiles.rules = concatMap (x: [ "d ${x} 0755 druid druid" ]) (cfg.commonTmpDirs ++ tmpDirs);
        };
        networking.firewall.allowedTCPPorts = mkIf (attrByPath [
          "openFirewall"
        ] false serviceOptions) allowedTCPPorts;

        users = {
          users.druid = {
            description = "Druid user";
            group = "druid";
            isNormalUser = true;
          };
          groups.druid = { };
        };
      }
      extraConfig
    ]));
in
{
  options.services.druid = {
    package = mkPackageOption pkgs "apache-druid" { default = [ "druid" ]; };

    commonConfig = mkOption {
      default = { };

      type = types.attrsOf types.anything;

      description = "(key=value) Configuration to be written to common.runtime.properties";

      example = {
        "druid.zk.service.host" = "localhost:2181";
        "druid.metadata.storage.type" = "mysql";
        "druid.metadata.storage.connector.connectURI" = "jdbc:mysql://localhost:3306/druid";
        "druid.extensions.loadList" = ''[ "mysql-metadata-storage" ]'';
      };
    };

    commonTmpDirs = mkOption {
      default = [ "/var/log/druid/requests" ];
      type = types.listOf types.str;
      description = "Common List of directories used by druid processes";
    };

    log4j = mkOption {
      type = types.path;
      description = "Log4j Configuration for the druid process";
    };

    extraClassPaths = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "Extra classpath to include in the jvm";
    };

    extraConfDirs = mkOption {
      default = [ ];
      type = types.listOf types.path;
      description = "Extra Conf Dirs to include in the jvm";
    };

    overlord = druidServiceOption "Druid Overlord";

    coordinator = druidServiceOption "Druid Coordinator";

    broker = druidServiceOption "Druid Broker";

    historical = (druidServiceOption "Druid Historical") // {
      segmentLocations = mkOption {

        default = null;

        description = "Locations where the historical will store its data.";

        type =
          with types;
          nullOr (
            listOf (submodule {
              options = {
                path = mkOption {
                  type = path;
                  description = "the path to store the segments";
                };

                maxSize = mkOption {
                  type = str;
                  description = "Max size the druid historical can occupy";
                };

                freeSpacePercent = mkOption {
                  type = float;
                  default = 1.0;
                  description = "Druid Historical will fail to write if it exceeds this value";
                };
              };
            })
          );

      };
    };

    middleManager = druidServiceOption "Druid middleManager";
    router = druidServiceOption "Druid Router";
  };
  config = mkMerge [
    (druidServiceConfig rec {
      name = "overlord";
      allowedTCPPorts = [ (attrByPath [ "druid.plaintextPort" ] 8090 cfg."${name}".config) ];
    })

    (druidServiceConfig rec {
      name = "coordinator";
      allowedTCPPorts = [ (attrByPath [ "druid.plaintextPort" ] 8081 cfg."${name}".config) ];
    })

    (druidServiceConfig rec {
      name = "broker";

      tmpDirs = [ (attrByPath [ "druid.lookup.snapshotWorkingDir" ] "" cfg."${name}".config) ];

      allowedTCPPorts = [ (attrByPath [ "druid.plaintextPort" ] 8082 cfg."${name}".config) ];
    })

    (druidServiceConfig rec {
      name = "historical";

      tmpDirs = [
        (attrByPath [ "druid.lookup.snapshotWorkingDir" ] "" cfg."${name}".config)
      ] ++ (map (x: x.path) cfg."${name}".segmentLocations);

      allowedTCPPorts = [ (attrByPath [ "druid.plaintextPort" ] 8083 cfg."${name}".config) ];

      extraConfig.services.druid.historical.internalConfig."druid.segmentCache.locations" = builtins.toJSON cfg.historical.segmentLocations;
    })

    (druidServiceConfig rec {
      name = "middleManager";

      tmpDirs = [
        "/var/log/druid/indexer"
      ] ++ [ (attrByPath [ "druid.indexer.task.baseTaskDir" ] "" cfg."${name}".config) ];

      allowedTCPPorts = [ (attrByPath [ "druid.plaintextPort" ] 8091 cfg."${name}".config) ];

      extraConfig = {
        services.druid.middleManager.internalConfig = {
          "druid.indexer.runner.javaCommand" = "${cfg.middleManager.jdk}/bin/java";
          "druid.indexer.runner.javaOpts" =
            (attrByPath [ "druid.indexer.runner.javaOpts" ] "" cfg.middleManager.config)
            + " -Dlog4j.configurationFile=file:${cfg.log4j}";
        };

        networking.firewall.allowedTCPPortRanges = mkIf cfg.middleManager.openFirewall [
          {
            from = attrByPath [ "druid.indexer.runner.startPort" ] 8100 cfg.middleManager.config;
            to = attrByPath [ "druid.indexer.runner.endPort" ] 65535 cfg.middleManager.config;
          }
        ];
      };
    })

    (druidServiceConfig rec {
      name = "router";

      allowedTCPPorts = [ (attrByPath [ "druid.plaintextPort" ] 8888 cfg."${name}".config) ];
    })
  ];

}
