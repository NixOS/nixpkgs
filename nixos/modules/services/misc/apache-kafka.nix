{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.apache-kafka;

  # The `javaProperties` generator takes care of various escaping rules and
  # generation of the properties file, but we'll handle stringly conversion
  # ourselves in mkPropertySettings and stringlySettings, since we know more
  # about the specifically allowed format eg. for lists of this type, and we
  # don't want to coerce-downsample values to str too early by having the
  # coercedTypes from javaProperties directly in our NixOS option types.
  #
  # Make sure every `freeformType` and any specific option type in `settings` is
  # supported here.

  mkPropertyString = let
    render = {
      bool = boolToString;
      int = toString;
      list = concatMapStringsSep "," mkPropertyString;
      string = id;
    };
  in
    v: render.${builtins.typeOf v} v;

  stringlySettings = mapAttrs (_: mkPropertyString)
    (filterAttrs (_: v:  v != null) cfg.settings);

  generator = (pkgs.formats.javaProperties {}).generate;
in {

  options.services.apache-kafka = {
    enable = mkEnableOption (lib.mdDoc "Apache Kafka event streaming broker");

    settings = mkOption {
      description = lib.mdDoc ''
        [Kafka broker configuration](https://kafka.apache.org/documentation.html#brokerconfigs)
        {file}`server.properties`.

        Note that .properties files contain mappings from string to string.
        Keys with dots are NOT represented by nested attrs in these settings,
        but instead as quoted strings (ie. `settings."broker.id"`, NOT
        `settings.broker.id`).
     '';
      type = types.submodule {
        freeformType = with types; let
          primitive = oneOf [bool int str];
        in lazyAttrsOf (nullOr (either primitive (listOf primitive)));

        options = {
          "broker.id" = mkOption {
            description = lib.mdDoc "Broker ID. -1 or null to auto-allocate in zookeeper mode.";
            default = null;
            type = with types; nullOr int;
          };

          "log.dirs" = mkOption {
            description = lib.mdDoc "Log file directories.";
            # Deliberaly leave out old default and use the rewrite opportunity
            # to have users choose a safer value -- /tmp might be volatile and is a
            # slightly scary default choice.
            # default = [ "/tmp/apache-kafka" ];
            type = with types; listOf path;
          };

          "listeners" = mkOption {
            description = lib.mdDoc ''
              Kafka Listener List.
              See [listeners](https://kafka.apache.org/documentation/#brokerconfigs_listeners).
            '';
            type = types.listOf types.str;
            default = [ "PLAINTEXT://localhost:9092" ];
          };
        };
      };
    };

    clusterId = mkOption {
      description = lib.mdDoc ''
        KRaft mode ClusterId used for formatting log directories. Can be generated with `kafka-storage.sh random-uuid`
      '';
      type = with types; nullOr str;
      default = null;
    };

    configFiles.serverProperties = mkOption {
      description = lib.mdDoc ''
        Kafka server.properties configuration file path.
        Defaults to the rendered `settings`.
      '';
      type = types.path;
    };

    configFiles.log4jProperties = mkOption {
      description = lib.mdDoc "Kafka log4j property configuration file path";
      type = types.path;
      default = pkgs.writeText "log4j.properties" cfg.log4jProperties;
      defaultText = ''pkgs.writeText "log4j.properties" cfg.log4jProperties'';
    };

    formatLogDirs = mkOption {
      description = lib.mdDoc ''
        Whether to format log dirs in KRaft mode if all log dirs are
        unformatted, ie. they contain no meta.properties.
      '';
      type = types.bool;
      default = false;
    };

    formatLogDirsIgnoreFormatted = mkOption {
      description = lib.mdDoc ''
        Whether to ignore already formatted log dirs when formatting log dirs,
        instead of failing. Useful when replacing or adding disks.
      '';
      type = types.bool;
      default = false;
    };

    log4jProperties = mkOption {
      description = lib.mdDoc "Kafka log4j property configuration.";
      default = ''
        log4j.rootLogger=INFO, stdout

        log4j.appender.stdout=org.apache.log4j.ConsoleAppender
        log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
        log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n
      '';
      type = types.lines;
    };

    jvmOptions = mkOption {
      description = lib.mdDoc "Extra command line options for the JVM running Kafka.";
      default = [];
      type = types.listOf types.str;
      example = [
        "-Djava.net.preferIPv4Stack=true"
        "-Dcom.sun.management.jmxremote"
        "-Dcom.sun.management.jmxremote.local.only=true"
      ];
    };

    package = mkPackageOption pkgs "apacheKafka" { };

    jre = mkOption {
      description = lib.mdDoc "The JRE with which to run Kafka";
      default = cfg.package.passthru.jre;
      defaultText = literalExpression "pkgs.apacheKafka.passthru.jre";
      type = types.package;
    };
  };

  imports = [
    (mkRenamedOptionModule
      [ "services" "apache-kafka" "brokerId" ]
      [ "services" "apache-kafka" "settings" ''broker.id'' ])
    (mkRenamedOptionModule
      [ "services" "apache-kafka" "logDirs" ]
      [ "services" "apache-kafka" "settings" ''log.dirs'' ])
    (mkRenamedOptionModule
      [ "services" "apache-kafka" "zookeeper" ]
      [ "services" "apache-kafka" "settings" ''zookeeper.connect'' ])

    (mkRemovedOptionModule [ "services" "apache-kafka" "port" ]
      "Please see services.apache-kafka.settings.listeners and its documentation instead")
    (mkRemovedOptionModule [ "services" "apache-kafka" "hostname" ]
      "Please see services.apache-kafka.settings.listeners and its documentation instead")
    (mkRemovedOptionModule [ "services" "apache-kafka" "extraProperties" ]
      "Please see services.apache-kafka.settings and its documentation instead")
    (mkRemovedOptionModule [ "services" "apache-kafka" "serverProperties" ]
      "Please see services.apache-kafka.settings and its documentation instead")
  ];

  config = mkIf cfg.enable {
    services.apache-kafka.configFiles.serverProperties = generator "server.properties" stringlySettings;

    users.users.apache-kafka = {
      isSystemUser = true;
      group = "apache-kafka";
      description = "Apache Kafka daemon user";
    };
    users.groups.apache-kafka = {};

    systemd.tmpfiles.rules = map (logDir: "d '${logDir}' 0700 apache-kafka - - -") cfg.settings."log.dirs";

    systemd.services.apache-kafka = {
      description = "Apache Kafka Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = mkIf cfg.formatLogDirs
        (if cfg.formatLogDirsIgnoreFormatted then ''
          ${cfg.package}/bin/kafka-storage.sh format -t "${cfg.clusterId}" -c ${cfg.configFiles.serverProperties} --ignore-formatted
        '' else ''
          if ${concatMapStringsSep " && " (l: ''[ ! -f "${l}/meta.properties" ]'') cfg.settings."log.dirs"}; then
            ${cfg.package}/bin/kafka-storage.sh format -t "${cfg.clusterId}" -c ${cfg.configFiles.serverProperties}
          fi
        '');
      serviceConfig = {
        ExecStart = ''
          ${cfg.jre}/bin/java \
            -cp "${cfg.package}/libs/*" \
            -Dlog4j.configuration=file:${cfg.configFiles.log4jProperties} \
            ${toString cfg.jvmOptions} \
            kafka.Kafka \
            ${cfg.configFiles.serverProperties}
        '';
        User = "apache-kafka";
        SuccessExitStatus = "0 143";
      };
    };
  };

  meta.doc = ./kafka.md;
  meta.maintainers = with lib.maintainers; [
    srhb
  ];
}
