{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tomcat;

  stateDir = "/var/lib/tomcat";
  cacheDir = "/var/cache/tomcat";

  # build an immutable configuration directory
  configDir = pkgs.runCommand "tomcat-conf" {} ''
    mkdir -p $out/conf
    cp ${cfg.package}/conf/* $out/conf/

    chmod -R u+w $out/conf

    ${concatStringsSep "\n" (mapAttrsToList (n: v: "ln -sf ${v} $out/conf/${n}") cfg.configFiles)}
  '';

  vhosts = attrValues cfg.virtualHosts;
  vhostsSSL = filter (hostOpts: hostOpts.addSSL || hostOpts.forceSSL || hostOpts.onlySSL) vhosts;
  native = any (connector: connector.protocol == "org.apache.coyote.http11.Http11AprProtocol") cfg.connectors;

  defaultConnectors = mkMerge [
    (mkIf (vhostsSSL == []) {
      port = 8080;
      protocol = "HTTP/1.1";
      connectionTimeout = 20000;
    })
    (mkIf (vhostsSSL != []) {
      port = 443;
      SSLEnabled = true;
      scheme = "https";
      protocol = "org.apache.coyote.http11.Http11AprProtocol"; # supports PEM
      secure = true;
      defaultSSLHostConfigName = (head vhosts).hostName; # FIXME: something better than this would be ideal...
      extraConfig = ''
        <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol" />
      '';
    })
    (mkIf (vhostsSSL != [] && !all (hostOpts: hostOpts.onlySSL) vhosts) {
      port = 80;
      protocol = "HTTP/1.1";
      connectionTimeout = 20000;
      redirectPort = 443;
    })
  ];

  toStr = v: if isBool v then boolToString v else toString v;

  mkListenerConf = listener: ''
    <Listener ${concatStringsSep " " (mapAttrsToList (k: v: "${k}=\"${toStr v}\"") listener)} />
  '';

  mkConnectorConf = connector: ''
    <Connector ${concatStringsSep " " (mapAttrsToList (k: v: optionalString (k != "extraConfig") "${k}=\"${toStr v}\"") connector)}>
      ${optionalString (hasAttr "extraConfig" connector) connector.extraConfig}
      ${optionalString (connector.SSLEnabled or false) (concatMapStrings mkSSLHostConf vhostsSSL)}
    </Connector>
  '';

  mkSSLHostConf = hostOpts:
    let
      useACME = hostOpts.enableACME || hostOpts.useACMEHost != null;
      sslCertDir =
        if hostOpts.enableACME then config.security.acme.certs.${hostOpts.hostName}.directory
        else if hostOpts.useACMEHost != null then config.security.acme.certs.${hostOpts.useACMEHost}.directory
        else abort "This case should never happen.";

      sslServerCert = if useACME then "${sslCertDir}/full.pem" else hostOpts.sslServerCert;
      sslServerKey = if useACME then "${sslCertDir}/key.pem" else hostOpts.sslServerKey;
      sslServerChain = if useACME then "${sslCertDir}/fullchain.pem" else hostOpts.sslServerChain;

      # https://ssl-config.mozilla.org/#server=tomcat&version=9.0.30&config=intermediate&guideline=5.4
      defaultAttrs = {
        inherit (hostOpts) hostName;

        ciphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
        disableSessionTickets = true;
        honorCipherOrder = false;
        protocols = concatStringsSep " " ([ "TLSv1.2" ] ++ optional (versionAtLeast cfg.jdk.version "11.0") "TLSv1.3");
      };
    in
      ''
        <SSLHostConfig ${concatStringsSep " " (mapAttrsToList (k: v: "${k}=\"${toStr v}\"") (defaultAttrs // hostOpts.sslHostConfig))}>
          <Certificate
            certificateKeyFile="${sslServerKey}"
            certificateFile="${sslServerCert}"
            certificateChainFile="${sslServerChain}"
          />
        </SSLHostConfig>
      ''
  ;

  mkVHostConf = hostOpts:
    let
      useACME = hostOpts.enableACME; # TODO: don't try to serve up directories that don't exist - ie. are we using DNS challenge? || hostOpts.useACMEHost != null;
      acmeChallenge = optionalString useACME ''
        <Context docBase="${hostOpts.acmeRoot}/.well-known/acme-challenge" path="/.well-known/acme-challenge" />
      '';
      robotsEntries = optionalString (hostOpts.robotsEntries != "") ''
        <Context docBase="${pkgs.writeText "robots.txt" hostOpts.robotsEntries}" path="/robots.txt" />
      '';

      # the following attributes allow tomcat to function with an immutable configuration directory
      # see: https://tomcat.apache.org/tomcat-9.0-doc/config/host.html
      defaultAttrs = {
        name = hostOpts.hostName;
        appBase = hostOpts.appBase;
        unpackWARs = true;
        autoDeploy = true;
        xmlBase = "${stateDir}/CATALINA/${hostOpts.hostName}";
        workDir = "${cacheDir}/${hostOpts.hostName}";
      };
    in
      ''
        <Host ${concatStringsSep " " (mapAttrsToList (k: v: "${k}=\"${toStr v}\"") (defaultAttrs // hostOpts.settings))}>
          ${concatMapStrings (alias: "<Alias>${alias}</Alias>") hostOpts.serverAliases}
          ${acmeChallenge}
          ${robotsEntries}
          ${optionalString (hostOpts.logFormat != null) ''
            <Valve
              className="org.apache.catalina.valves.AccessLogValve"
              directory="${cfg.logDir}"
              prefix="${hostOpts.hostName}_access" suffix=".log"
              pattern="${hostOpts.logFormat}"
            />
          ''}
          ${hostOpts.extraConfig}
        </Host>
      ''
  ;

  serverXmlFile = pkgs.writeText "server.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!--
      This is a generated file.  Do not edit!

      To make changes, edit the services.tomcat NixOS options
      in your /etc/nixos/configuration.nix file.
    -->
    <Server ${concatStringsSep " " (mapAttrsToList (k: v: "${k}=\"${toStr v}\"") cfg.serverAttrs)}>
      ${concatMapStrings mkListenerConf cfg.listeners}
      ${cfg.extraConfig}

      <Service ${concatStringsSep " " (mapAttrsToList (k: v: "${k}=\"${toStr v}\"") cfg.serviceAttrs)}>
        ${concatMapStrings mkConnectorConf cfg.connectors}

        <Engine ${concatStringsSep " " (mapAttrsToList (k: v: "${k}=\"${toStr v}\"") cfg.engineAttrs)}>
          ${concatMapStrings mkVHostConf vhosts}
        </Engine>
      </Service>
    </Server>
  '';

  # log to console (journald)
  loggingProperties = pkgs.writeText "logging.properties" ''
    handlers = java.util.logging.ConsoleHandler

    .handlers = java.util.logging.ConsoleHandler

    java.util.logging.ConsoleHandler.level = FINE
    java.util.logging.ConsoleHandler.formatter = org.apache.juli.OneLineFormatter
  '';
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "tomcat" "purifyOnStart" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "baseDir" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "logDirs" ] "See services.tomcat.logDir and journald")
    (mkRemovedOptionModule [ "services" "tomcat" "extraConfigFiles" ] "See services.tomcat.configFiles.")
    (mkRemovedOptionModule [ "services" "tomcat" "extraEnvironment" ] "use systemd options")
    (mkRemovedOptionModule [ "services" "tomcat" "extraGroups" ] "use systemd options")
    (mkRemovedOptionModule [ "services" "tomcat" "sharedLibs" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "serverXml" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "commonLibs" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "webapps" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "logPerVirtualHost" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "axis2" "enable" ] "")
    (mkRemovedOptionModule [ "services" "tomcat" "axis2" "services" ] "")
  ];

  # interface
  options = {

    services.tomcat = {

      enable = mkEnableOption "Apache Tomcat";

      serverAttrs = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        default = {
          port = 8005;
          shutdown = "SHUTDOWN";
        };
        example = literalExample ''
          { }
        '';
        description = ''
          Attributes to apply to the <literal>Server</literal> element of
          <literal>server.xml</literal>. Refer to
          <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/server.html"/>
          for details.

          <note><para>The provided example would disable the remote shutdown capability of <literal>tomcat</literal>.</para></note>
        '';
      };

      serviceAttrs = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        description = ''
          Attributes to apply to the <literal>Service</literal> element of
          <literal>server.xml</literal>. Refer to
          <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/service.html"/>
          for details.
        '';
      };

      engineAttrs = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        example = literalExample ''
          {
            defaultHost = "example.org";
          }
        '';
        description = ''
          Attributes to apply to the <literal>Engine</literal> element of
          <literal>server.xml</literal>. Refer to
          <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/engine.html"/>
          for details.
        '';
      };

      connectors = mkOption {
        type = with types; listOf (attrsOf (oneOf [ bool int str ]));
        default = defaultConnectors;
        defaultText = ''
        '';
        example = [
          { port = 8009;
            redirectPort = 8443;
            protocol = "AJP/1.3";
          }
          { port = 8080;
            protocol = "HTTP/1.1";
            redirectPort = 8443;
            connectionTimeout = 20000;
          }
          { port = 8443;
            SSLEnabled = true;
            protocol = "org.apache.coyote.http11.Http11AprProtocol";
            extraConfig = ''
              <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol" />
            '';
          }
        ];
        description = ''
          List of attribute sets for each <literal>Connector</literal> elements to define in
          <literal>server.xml</literal>.

          Refer to the following documentation for details on each <literal>Connector</literal> type,
          as well as a comparison:

          <itemizedlist>
            <listitem>
              <para>
                <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html">HTTP/1.1</link>
              </para>
            </listitem>
            <listitem>
              <para>
                <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http2.html">HTTP/2</link>
              </para>
            </listitem>
            <listitem>
              <para>
                <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/ajp.html">AJP</link>
              </para>
            </listitem>
            <listitem>
              <para>
                <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/http.html#Connector_Comparison">Connector Comparison</link>
              </para>
            </listitem>
          </itemizedlist>

          <note>
            <para>
              The contents of an attribute named <literal>extraConfig</literal> will be appended as literal XML
              into the <literal>Connector</literal> element.
            </para>
          </note>
        '';
      };

      listeners = mkOption {
        type = with types; listOf (attrsOf (oneOf [ bool int str ]));
        example = literalExample ''
          lib.mkForce [
            { className = "org.apache.catalina.startup.VersionLoggerListener";
              logArgs = true;
              logEnv = true;
              logProps = true;
            }
            { className = "org.apache.catalina.core.JreMemoryLeakPreventionListener"; }
            { className = "org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"; }
            { className = "org.apache.catalina.core.ThreadLocalLeakPreventionListener"; }
          ];
        '';
        description = ''
          Applies <literal>Listener</literal> elements to the <literal>Server</literal> section
          of <literal>server.xml</literal>. Refer to
          <link xlink:href="https://tomcat.apache.org/tomcat-9.0-doc/config/listeners.html"/>
          for details.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.tomcat9;
        defaultText = "pkgs.tomcat9";
        example = lib.literalExample "pkgs.tomcat85";
        description = ''
          Which tomcat package to use.
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/tomcat";
        description = ''
          Directory to store access logs.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
        '';
        description = ''
          These lines are copied into <literal>server.xml</literal> verbatim.

          They will go after directories and directory aliases defined by default.
        '';
      };

      configFiles = mkOption {
        type = with types; attrsOf path;
        default = {};
        description = ''
        '';
        example = literalExample ''
          {
            "server.xml" = "/path/to/custom/server.xml";
          }
        '';
      };

      user = mkOption {
        type = types.str;
        default = "tomcat";
        description = ''
          User account under which Apache Tomcat runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "tomcat";
        description = ''
          Group account under which Apache Tomcat runs.
        '';
      };

      javaOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Parameters to pass to the Java Virtual Machine which spawns Apache Tomcat.
        '';
      };

      catalinaOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Parameters to pass to the Java Virtual Machine which spawns the Catalina servlet container.
        '';
      };

      virtualHosts = mkOption {
        type = with types; attrsOf (submodule (import ./vhost-options.nix));
        default = {
          localhost = {
            appBase = "${cfg.package.webapps}/webapps";
          };
        };
        example = literalExample ''
          "example.org" = {
            appBase = "/www/tomcat";
            enableACME = true;
            forceSSL = true;
          };
        '';
        description = ''
          List consisting of a virtual host name and a list of web applications to deploy on each virtual host
        '';
      };

      jdk = mkOption {
        type = types.package;
        default = pkgs.jdk;
        defaultText = "pkgs.jdk";
        description = "Which JDK to use.";
      };

    };
  };

  # implementation
  config = mkIf cfg.enable {

    assertions = [
      { assertion = all (hostOpts: with hostOpts; !(addSSL && onlySSL) && !(forceSSL && onlySSL) && !(addSSL && forceSSL)) vhosts;
        message = ''
          Options `services.httpd.virtualHosts.<name>.addSSL`,
          `services.httpd.virtualHosts.<name>.onlySSL` and `services.httpd.virtualHosts.<name>.forceSSL`
          are mutually exclusive.
        '';
      }
      { assertion = all (hostOpts: !(hostOpts.enableACME && hostOpts.useACMEHost != null)) vhosts;
        message = ''
          Options `services.httpd.virtualHosts.<name>.enableACME` and
          `services.httpd.virtualHosts.<name>.useACMEHost` are mutually exclusive.
        '';
      }
      { assertion = hasAttr "defaultHost" cfg.engineAttrs && hasAttr cfg.engineAttrs.defaultHost cfg.virtualHosts;
        message = ''
          Please choose a default host for `tomcat` by setting `services.tomcat.engineAttrs.defaultHost` to one of: ${concatStringsSep ", " (builtins.attrNames cfg.virtualHosts)}
        '';
      }
      { assertion = cfg.connectors != [];
        message = ''
          Please add at least one tomcat connector to `services.tomcat.connectors`.
        '';
      }
      { assertion = all (hostOpts: hostOpts.webapps == []) vhosts;
        message = ''
          The option definition `services.tomcat.*.webapps' no longer has any effect; please remove it.
          See <INSERT LINK TO NEW TOMCAT GUIDE, MIGRATION SECTION>.
        '';
      }
    ];

    users.users = optionalAttrs (cfg.user == "tomcat") {
      tomcat = {
        group = cfg.group;
        description = "Tomcat user";
        uid = config.ids.uids.tomcat;
        home = "/homeless-shelter";
      };
    };

    users.groups = optionalAttrs (cfg.group == "tomcat") {
      tomcat.gid = config.ids.gids.tomcat;
    };

    services.tomcat.javaOpts = [ "-Djava.awt.headless=true" ] ++ optionals native [ "-Djava.library.path=${pkgs.tomcat-native}/lib" ];

    services.tomcat.serviceAttrs = mapAttrs (name: mkDefault) {
      name = "Catalina";
    };
    services.tomcat.engineAttrs = mapAttrs (name: mkDefault) {
      name = "Catalina";
    } // optionalAttrs (builtins.length vhosts == 1) {
      defaultHost = (head vhosts).hostName;
    };

    services.tomcat.listeners = [
      { className = "org.apache.catalina.startup.VersionLoggerListener"; }
      { className = "org.apache.catalina.core.JreMemoryLeakPreventionListener"; }
      { className = "org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"; }
      { className = "org.apache.catalina.core.ThreadLocalLeakPreventionListener"; }
    ] ++ optionals native [
      { className = "org.apache.catalina.core.AprLifecycleListener"; SSLEngine = "on"; }
    ];

    services.tomcat.extraConfig = ''
      <GlobalNamingResources>
        <!-- Editable user database that can also be used by UserDatabaseRealm to authenticate users -->
        <Resource
          name="UserDatabase"
          auth="Container"
          type="org.apache.catalina.UserDatabase"
          description="User database that can be updated and saved"
          factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
          pathname="conf/tomcat-users.xml"
        />
      </GlobalNamingResources>
    '';

    services.tomcat.configFiles = mapAttrs (name: mkDefault) {
      "server.xml" = serverXmlFile;
      "logging.properties" = loggingProperties;
    };

    security.acme.certs = mapAttrs (name: hostOpts: {
      user = cfg.user;
      group = mkDefault cfg.group;
      webroot = hostOpts.acmeRoot;
      extraDomains = genAttrs hostOpts.serverAliases (alias: null);
      postRun = "systemctl restart tomcat.service"; # TODO: reload ssl instead of full restart
    }) (filterAttrs (name: hostOpts: hostOpts.enableACME) cfg.virtualHosts);

    systemd.tmpfiles.rules = [
      "d '${cfg.logDir}' 0755" # TODO: 0700"
    ];

    systemd.services.tomcat =
      let
        vhostsACME = filter (hostOpts: hostOpts.enableACME) vhosts;
      in
      {
        description = "Apache Tomcat server";
        wantedBy = [ "multi-user.target" ];
        wants = concatLists (map (hostOpts: [ "acme-${hostOpts.hostName}.service" "acme-selfsigned-${hostOpts.hostName}.service" ]) vhostsACME);
        after = [ "network.target" ] ++ map (hostOpts: "acme-selfsigned-${hostOpts.hostName}.service") vhostsACME;

        environment = {
          CATALINA_BASE = configDir;
          CATALINA_HOME = cfg.package;
          CATALINA_OPTS = builtins.toString cfg.catalinaOpts;
          CATALINA_TMPDIR = "/tmp";
          JAVA_HOME = cfg.jdk;
          JAVA_OPTS = builtins.toString cfg.javaOpts;
        };

        # https://jdebp.eu/FGA/systemd-house-of-horror/tomcat.html
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          # TODO: set [Cache|Runtime|State]DirectoryMode = "0750" ... or probably "0700"?, and decide which directories are needed
          CacheDirectory = "tomcat";
          RuntimeDirectory = "tomcat";
          StateDirectory = "tomcat";
          ExecStart = "${cfg.package}/bin/catalina.sh run";
          PrivateTmp = true;
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        };
      };
  };
}
