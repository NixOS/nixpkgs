{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.neo4j;
  opt = options.services.neo4j;
  certDirOpt = options.services.neo4j.directories.certificates;
  isDefaultPathOption = opt: isOption opt && opt.type == types.path && opt.highestPrio >= 1500;

  sslPolicies = mapAttrsToList (
    name: conf: ''
      dbms.ssl.policy.${name}.allow_key_generation=${boolToString conf.allowKeyGeneration}
      dbms.ssl.policy.${name}.base_directory=${conf.baseDirectory}
      ${optionalString (conf.ciphers != null) ''
        dbms.ssl.policy.${name}.ciphers=${concatStringsSep "," conf.ciphers}
      ''}
      dbms.ssl.policy.${name}.client_auth=${conf.clientAuth}
      ${if length (splitString "/" conf.privateKey) > 1 then
        "dbms.ssl.policy.${name}.private_key=${conf.privateKey}"
      else
        "dbms.ssl.policy.${name}.private_key=${conf.baseDirectory}/${conf.privateKey}"
      }
      ${if length (splitString "/" conf.privateKey) > 1 then
        "dbms.ssl.policy.${name}.public_certificate=${conf.publicCertificate}"
      else
        "dbms.ssl.policy.${name}.public_certificate=${conf.baseDirectory}/${conf.publicCertificate}"
      }
      dbms.ssl.policy.${name}.revoked_dir=${conf.revokedDir}
      dbms.ssl.policy.${name}.tls_versions=${concatStringsSep "," conf.tlsVersions}
      dbms.ssl.policy.${name}.trust_all=${boolToString conf.trustAll}
      dbms.ssl.policy.${name}.trusted_dir=${conf.trustedDir}
    ''
  ) cfg.ssl.policies;

  serverConfig = pkgs.writeText "neo4j.conf" ''
    # General
    dbms.allow_upgrade=${boolToString cfg.allowUpgrade}
    dbms.connectors.default_listen_address=${cfg.defaultListenAddress}
    dbms.read_only=${boolToString cfg.readOnly}
    ${optionalString (cfg.workerCount > 0) ''
      dbms.threads.worker_count=${toString cfg.workerCount}
    ''}

    # Directories
    dbms.directories.certificates=${cfg.directories.certificates}
    dbms.directories.data=${cfg.directories.data}
    dbms.directories.logs=${cfg.directories.home}/logs
    dbms.directories.plugins=${cfg.directories.plugins}
    ${optionalString (cfg.constrainLoadCsv) ''
      dbms.directories.import=${cfg.directories.imports}
    ''}

    # HTTP Connector
    ${optionalString (cfg.http.enable) ''
      dbms.connector.http.enabled=${boolToString cfg.http.enable}
      dbms.connector.http.listen_address=${cfg.http.listenAddress}
    ''}
    ${optionalString (!cfg.http.enable) ''
      # It is not possible to disable the HTTP connector. To fully prevent
      # clients from connecting to HTTP, block the HTTP port (7474 by default)
      # via firewall. listen_address is set to the loopback interface to
      # prevent remote clients from connecting.
      dbms.connector.http.listen_address=127.0.0.1
    ''}

    # HTTPS Connector
    dbms.connector.https.enabled=${boolToString cfg.https.enable}
    dbms.connector.https.listen_address=${cfg.https.listenAddress}
    https.ssl_policy=${cfg.https.sslPolicy}

    # BOLT Connector
    dbms.connector.bolt.enabled=${boolToString cfg.bolt.enable}
    dbms.connector.bolt.listen_address=${cfg.bolt.listenAddress}
    bolt.ssl_policy=${cfg.bolt.sslPolicy}
    dbms.connector.bolt.tls_level=${cfg.bolt.tlsLevel}

    # neo4j-shell
    dbms.shell.enabled=${boolToString cfg.shell.enable}

    # SSL Policies
    ${concatStringsSep "\n" sslPolicies}

    # Default retention policy from neo4j.conf
    dbms.tx_log.rotation.retention_policy=1 days

    # Default JVM parameters from neo4j.conf
    dbms.jvm.additional=-XX:+UseG1GC
    dbms.jvm.additional=-XX:-OmitStackTraceInFastThrow
    dbms.jvm.additional=-XX:+AlwaysPreTouch
    dbms.jvm.additional=-XX:+UnlockExperimentalVMOptions
    dbms.jvm.additional=-XX:+TrustFinalNonStaticFields
    dbms.jvm.additional=-XX:+DisableExplicitGC
    dbms.jvm.additional=-Djdk.tls.ephemeralDHKeySize=2048
    dbms.jvm.additional=-Djdk.tls.rejectClientInitiatedRenegotiation=true
    dbms.jvm.additional=-Dunsupported.dbms.udc.source=tarball

    # Usage Data Collector
    dbms.udc.enabled=${boolToString cfg.udc.enable}

    # Extra Configuration
    ${cfg.extraServerConfig}
  '';

in {

  imports = [
    (mkRenamedOptionModule [ "services" "neo4j" "host" ] [ "services" "neo4j" "defaultListenAddress" ])
    (mkRenamedOptionModule [ "services" "neo4j" "listenAddress" ] [ "services" "neo4j" "defaultListenAddress" ])
    (mkRenamedOptionModule [ "services" "neo4j" "enableBolt" ] [ "services" "neo4j" "bolt" "enable" ])
    (mkRenamedOptionModule [ "services" "neo4j" "enableHttps" ] [ "services" "neo4j" "https" "enable" ])
    (mkRenamedOptionModule [ "services" "neo4j" "certDir" ] [ "services" "neo4j" "directories" "certificates" ])
    (mkRenamedOptionModule [ "services" "neo4j" "dataDir" ] [ "services" "neo4j" "directories" "home" ])
    (mkRemovedOptionModule [ "services" "neo4j" "port" ] "Use services.neo4j.http.listenAddress instead.")
    (mkRemovedOptionModule [ "services" "neo4j" "boltPort" ] "Use services.neo4j.bolt.listenAddress instead.")
    (mkRemovedOptionModule [ "services" "neo4j" "httpsPort" ] "Use services.neo4j.https.listenAddress instead.")
  ];

  ###### interface

  options.services.neo4j = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable Neo4j Community Edition.
      '';
    };

    allowUpgrade = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Allow upgrade of Neo4j database files from an older version.
      '';
    };

    constrainLoadCsv = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Sets the root directory for file URLs used with the Cypher
        `LOAD CSV` clause to be that defined by
        {option}`directories.imports`. It restricts
        access to only those files within that directory and its
        subdirectories.

        Setting this option to `false` introduces
        possible security problems.
      '';
    };

    defaultListenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Default network interface to listen for incoming connections. To
        listen for connections on all interfaces, use "0.0.0.0".

        Specifies the default IP address and address part of connector
        specific {option}`listenAddress` options. To bind specific
        connectors to a specific network interfaces, specify the entire
        {option}`listenAddress` option for that connector.
      '';
    };

    extraServerConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra configuration for Neo4j Community server. Refer to the
        [complete reference](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings/)
        of Neo4j configuration settings.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.neo4j;
      defaultText = literalExpression "pkgs.neo4j";
      description = lib.mdDoc ''
        Neo4j package to use.
      '';
    };

    readOnly = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Only allow read operations from this Neo4j instance.
      '';
    };

    workerCount = mkOption {
      type = types.ints.between 0 44738;
      default = 0;
      description = lib.mdDoc ''
        Number of Neo4j worker threads, where the default of
        `0` indicates a worker count equal to the number of
        available processors.
      '';
    };

    bolt = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Enable the BOLT connector for Neo4j. Setting this option to
          `false` will stop Neo4j from listening for incoming
          connections on the BOLT port (7687 by default).
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = ":7687";
        description = lib.mdDoc ''
          Neo4j listen address for BOLT traffic. The listen address is
          expressed in the format `<ip-address>:<port-number>`.
        '';
      };

      sslPolicy = mkOption {
        type = types.str;
        default = "legacy";
        description = lib.mdDoc ''
          Neo4j SSL policy for BOLT traffic.

          The legacy policy is a special policy which is not defined in
          the policy configuration section, but rather derives from
          {option}`directories.certificates` and
          associated files (by default: {file}`neo4j.key` and
          {file}`neo4j.cert`). Its use will be deprecated.

          Note: This connector must be configured to support/require
          SSL/TLS for the legacy policy to actually be utilized. See
          {option}`bolt.tlsLevel`.
        '';
      };

      tlsLevel = mkOption {
        type = types.enum [ "REQUIRED" "OPTIONAL" "DISABLED" ];
        default = "OPTIONAL";
        description = lib.mdDoc ''
          SSL/TSL requirement level for BOLT traffic.
        '';
      };
    };

    directories = {
      certificates = mkOption {
        type = types.path;
        default = "${cfg.directories.home}/certificates";
        defaultText = literalExpression ''"''${config.${opt.directories.home}}/certificates"'';
        description = lib.mdDoc ''
          Directory for storing certificates to be used by Neo4j for
          TLS connections.

          When setting this directory to something other than its default,
          ensure the directory's existence, and that read/write permissions are
          given to the Neo4j daemon user `neo4j`.

          Note that changing this directory from its default will prevent
          the directory structure required for each SSL policy from being
          automatically generated. A policy's directory structure as defined by
          its {option}`baseDirectory`,{option}`revokedDir` and
          {option}`trustedDir` must then be setup manually. The
          existence of these directories is mandatory, as well as the presence
          of the certificate file and the private key. Ensure the correct
          permissions are set on these directories and files.
        '';
      };

      data = mkOption {
        type = types.path;
        default = "${cfg.directories.home}/data";
        defaultText = literalExpression ''"''${config.${opt.directories.home}}/data"'';
        description = lib.mdDoc ''
          Path of the data directory. You must not configure more than one
          Neo4j installation to use the same data directory.

          When setting this directory to something other than its default,
          ensure the directory's existence, and that read/write permissions are
          given to the Neo4j daemon user `neo4j`.
        '';
      };

      home = mkOption {
        type = types.path;
        default = "/var/lib/neo4j";
        description = lib.mdDoc ''
          Path of the Neo4j home directory. Other default directories are
          subdirectories of this path. This directory will be created if
          non-existent, and its ownership will be {command}`chown` to
          the Neo4j daemon user `neo4j`.
        '';
      };

      imports = mkOption {
        type = types.path;
        default = "${cfg.directories.home}/import";
        defaultText = literalExpression ''"''${config.${opt.directories.home}}/import"'';
        description = lib.mdDoc ''
          The root directory for file URLs used with the Cypher
          `LOAD CSV` clause. Only meaningful when
          {option}`constrainLoadCvs` is set to
          `true`.

          When setting this directory to something other than its default,
          ensure the directory's existence, and that read permission is
          given to the Neo4j daemon user `neo4j`.
        '';
      };

      plugins = mkOption {
        type = types.path;
        default = "${cfg.directories.home}/plugins";
        defaultText = literalExpression ''"''${config.${opt.directories.home}}/plugins"'';
        description = lib.mdDoc ''
          Path of the database plugin directory. Compiled Java JAR files that
          contain database procedures will be loaded if they are placed in
          this directory.

          When setting this directory to something other than its default,
          ensure the directory's existence, and that read permission is
          given to the Neo4j daemon user `neo4j`.
        '';
      };
    };

    http = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          The HTTP connector is required for Neo4j, and cannot be disabled.
          Setting this option to `false` will force the HTTP
          connector's {option}`listenAddress` to the loopback
          interface to prevent connection of remote clients. To prevent all
          clients from connecting, block the HTTP port (7474 by default) by
          firewall.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = ":7474";
        description = lib.mdDoc ''
          Neo4j listen address for HTTP traffic. The listen address is
          expressed in the format `<ip-address>:<port-number>`.
        '';
      };
    };

    https = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Enable the HTTPS connector for Neo4j. Setting this option to
          `false` will stop Neo4j from listening for incoming
          connections on the HTTPS port (7473 by default).
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = ":7473";
        description = lib.mdDoc ''
          Neo4j listen address for HTTPS traffic. The listen address is
          expressed in the format `<ip-address>:<port-number>`.
        '';
      };

      sslPolicy = mkOption {
        type = types.str;
        default = "legacy";
        description = lib.mdDoc ''
          Neo4j SSL policy for HTTPS traffic.

          The legacy policy is a special policy which is not defined in the
          policy configuration section, but rather derives from
          {option}`directories.certificates` and
          associated files (by default: {file}`neo4j.key` and
          {file}`neo4j.cert`). Its use will be deprecated.
        '';
      };
    };

    shell = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable a remote shell server which Neo4j Shell clients can log in to.
          Only applicable to {command}`neo4j-shell`.
        '';
      };
    };

    ssl.policies = mkOption {
      type = with types; attrsOf (submodule ({ name, config, options, ... }: {
        options = {

          allowKeyGeneration = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Allows the generation of a private key and associated self-signed
              certificate. Only performed when both objects cannot be found for
              this policy. It is recommended to turn this off again after keys
              have been generated.

              The public certificate is required to be duplicated to the
              directory holding trusted certificates as defined by the
              {option}`trustedDir` option.

              Keys should in general be generated and distributed offline by a
              trusted certificate authority and not by utilizing this mode.
            '';
          };

          baseDirectory = mkOption {
            type = types.path;
            default = "${cfg.directories.certificates}/${name}";
            defaultText = literalExpression ''"''${config.${opt.directories.certificates}}/''${name}"'';
            description = lib.mdDoc ''
              The mandatory base directory for cryptographic objects of this
              policy. This path is only automatically generated when this
              option as well as {option}`directories.certificates` are
              left at their default. Ensure read/write permissions are given
              to the Neo4j daemon user `neo4j`.

              It is also possible to override each individual
              configuration with absolute paths. See the
              {option}`privateKey` and {option}`publicCertificate`
              policy options.
            '';
          };

          ciphers = mkOption {
            type = types.nullOr (types.listOf types.str);
            default = null;
            description = lib.mdDoc ''
              Restrict the allowed ciphers of this policy to those defined
              here. The default ciphers are those of the JVM platform.
            '';
          };

          clientAuth = mkOption {
            type = types.enum [ "NONE" "OPTIONAL" "REQUIRE" ];
            default = "REQUIRE";
            description = lib.mdDoc ''
              The client authentication stance for this policy.
            '';
          };

          privateKey = mkOption {
            type = types.str;
            default = "private.key";
            description = lib.mdDoc ''
              The name of private PKCS #8 key file for this policy to be found
              in the {option}`baseDirectory`, or the absolute path to
              the key file. It is mandatory that a key can be found or generated.
            '';
          };

          publicCertificate = mkOption {
            type = types.str;
            default = "public.crt";
            description = lib.mdDoc ''
              The name of public X.509 certificate (chain) file in PEM format
              for this policy to be found in the {option}`baseDirectory`,
              or the absolute path to the certificate file. It is mandatory
              that a certificate can be found or generated.

              The public certificate is required to be duplicated to the
              directory holding trusted certificates as defined by the
              {option}`trustedDir` option.
            '';
          };

          revokedDir = mkOption {
            type = types.path;
            default = "${config.baseDirectory}/revoked";
            defaultText = literalExpression ''"''${config.${options.baseDirectory}}/revoked"'';
            description = lib.mdDoc ''
              Path to directory of CRLs (Certificate Revocation Lists) in
              PEM format. Must be an absolute path. The existence of this
              directory is mandatory and will need to be created manually when:
              setting this option to something other than its default; setting
              either this policy's {option}`baseDirectory` or
              {option}`directories.certificates` to something other than
              their default. Ensure read/write permissions are given to the
              Neo4j daemon user `neo4j`.
            '';
          };

          tlsVersions = mkOption {
            type = types.listOf types.str;
            default = [ "TLSv1.2" ];
            description = lib.mdDoc ''
              Restrict the TLS protocol versions of this policy to those
              defined here.
            '';
          };

          trustAll = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Makes this policy trust all remote parties. Enabling this is not
              recommended and the policy's trusted directory will be ignored.
              Use of this mode is discouraged. It would offer encryption but
              no security.
            '';
          };

          trustedDir = mkOption {
            type = types.path;
            default = "${config.baseDirectory}/trusted";
            defaultText = literalExpression ''"''${config.${options.baseDirectory}}/trusted"'';
            description = lib.mdDoc ''
              Path to directory of X.509 certificates in PEM format for
              trusted parties. Must be an absolute path. The existence of this
              directory is mandatory and will need to be created manually when:
              setting this option to something other than its default; setting
              either this policy's {option}`baseDirectory` or
              {option}`directories.certificates` to something other than
              their default. Ensure read/write permissions are given to the
              Neo4j daemon user `neo4j`.

              The public certificate as defined by
              {option}`publicCertificate` is required to be duplicated
              to this directory.
            '';
          };

          directoriesToCreate = mkOption {
            type = types.listOf types.path;
            internal = true;
            readOnly = true;
            description = ''
              Directories of this policy that will be created automatically
              when the certificates directory is left at its default value.
              This includes all options of type path that are left at their
              default value.
            '';
          };

        };

        config.directoriesToCreate = optionals
          (certDirOpt.highestPrio >= 1500 && options.baseDirectory.highestPrio >= 1500)
          (map (opt: opt.value) (filter isDefaultPathOption (attrValues options)));

      }));
      default = {};
      description = lib.mdDoc ''
        Defines the SSL policies for use with Neo4j connectors. Each attribute
        of this set defines a policy, with the attribute name defining the name
        of the policy and its namespace. Refer to the operations manual section
        on Neo4j's
        [SSL Framework](https://neo4j.com/docs/operations-manual/current/security/ssl-framework/)
        for further details.
      '';
    };

    udc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the Usage Data Collector which Neo4j uses to collect usage
          data. Refer to the operations manual section on the
          [Usage Data Collector](https://neo4j.com/docs/operations-manual/current/configuration/usage-data-collector/)
          for more information.
        '';
      };
    };

  };

  ###### implementation

  config =
    let
      # Assertion helpers
      policyNameList = attrNames cfg.ssl.policies;
      validPolicyNameList = [ "legacy" ] ++ policyNameList;
      validPolicyNameString = concatStringsSep ", " validPolicyNameList;

      # Capture various directories left at their default so they can be created.
      defaultDirectoriesToCreate = map (opt: opt.value) (filter isDefaultPathOption (attrValues options.services.neo4j.directories));
      policyDirectoriesToCreate = concatMap (pol: pol.directoriesToCreate) (attrValues cfg.ssl.policies);
    in

    mkIf cfg.enable {
      assertions = [
        { assertion = !elem "legacy" policyNameList;
          message = "The policy 'legacy' is special to Neo4j, and its name is reserved."; }
        { assertion = elem cfg.bolt.sslPolicy validPolicyNameList;
          message = "Invalid policy assigned: `services.neo4j.bolt.sslPolicy = \"${cfg.bolt.sslPolicy}\"`, defined policies are: ${validPolicyNameString}"; }
        { assertion = elem cfg.https.sslPolicy validPolicyNameList;
          message = "Invalid policy assigned: `services.neo4j.https.sslPolicy = \"${cfg.https.sslPolicy}\"`, defined policies are: ${validPolicyNameString}"; }
      ];

      systemd.services.neo4j = {
        description = "Neo4j Daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment = {
          NEO4J_HOME = "${cfg.package}/share/neo4j";
          NEO4J_CONF = "${cfg.directories.home}/conf";
        };
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/neo4j console";
          User = "neo4j";
          PermissionsStartOnly = true;
          LimitNOFILE = 40000;
        };

        preStart = ''
          # Directories Setup
          #   Always ensure home exists with nested conf, logs directories.
          mkdir -m 0700 -p ${cfg.directories.home}/{conf,logs}

          #   Create other sub-directories and policy directories that have been left at their default.
          ${concatMapStringsSep "\n" (
            dir: ''
              mkdir -m 0700 -p ${dir}
          '') (defaultDirectoriesToCreate ++ policyDirectoriesToCreate)}

          # Place the configuration where Neo4j can find it.
          ln -fs ${serverConfig} ${cfg.directories.home}/conf/neo4j.conf

          # Ensure neo4j user ownership
          chown -R neo4j ${cfg.directories.home}
        '';
      };

      environment.systemPackages = [ cfg.package ];

      users.users.neo4j = {
        isSystemUser = true;
        group = "neo4j";
        description = "Neo4j daemon user";
        home = cfg.directories.home;
      };
      users.groups.neo4j = {};
    };

  meta = {
    maintainers = with lib.maintainers; [ patternspandemic ];
  };
}
