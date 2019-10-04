{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.guacamole;
  uid = 54201;
  gid = 54201;

  guacamoleVersion = "0.9.14";
  guacamoleServer = pkgs.guacamole;
  guacamoleClient = pkgs.fetchurl {
    url = "mirror://sourceforge/guacamole/guacamole-${guacamoleVersion}.war";
    sha256 = "0kfr4g5nw0hl2wbxycvvy3h3avqk2k0q7xh0vlclk63a19rdjcc8";
  };

  tomcatWebappDir = pkgs.stdenv.mkDerivation {
    name = "guacamole-tomcat-webapp-dir";
    buildCommand = ''
      mkdir -p "$out/webapps"
      install -T "${guacamoleClient}" "$out/webapps/guacamole.war"
    '';
  };

  tomcatCommonLibDir = pkgs.stdenv.mkDerivation {
    name = "guacamole-tomcat-common-lib-dir";
    buildCommand = ''
      mkdir -p "$out/lib"
      install -T "${pkgs.postgresql_jdbc}/share/java/postgresql-jdbc.jar" "$out/lib/postgresql-jdbc.jar"
    '';
  };

  extensionAuth = builtins.fetchTarball {
    url = "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${guacamoleVersion}/binary/guacamole-auth-jdbc-${guacamoleVersion}.tar.gz";
    sha256 = "1n6fnzc3jc5r1a4bdbl5nc5h6178kaix7rvqdr1jpfb5i3rd2sb4";
  };

  homeExtensionsDir = pkgs.stdenv.mkDerivation {
    name = "guacamole-home-extensions-dir";
    buildCommand = ''
      mkdir -p "$out/extensions"
      auth_in_fn="guacamole-auth-jdbc-postgresql-${guacamoleVersion}.jar"
      auth_out_fn="$auth_in_fn"
      #install -T "${extensionAuth}/postgresql/$auth_in_fn" "$out/extensions/$auth_out_fn"
    '';
  };

  homePath = "${config.services.tomcat.baseDir}/webapps/guac";
  homePropertiesFilePath = "${homePath}/guacamole.properties";
  homeUserMappingFilePath = "${homePath}/user-mapping.xml";

  propertiesFilePath = if cfg.propertiesText != null
    then builtins.toFile "guacamole.properties" cfg.propertiesText
    else if cfg.propertiesFile != null
      then cfg.propertiesFile
      else pkgs.writeTextFile {
        name = "guacamole.properties";
        # The miminal working setup by default.
        # TODO: Configure these default using exposed attributes (e.g: port, hostname, etc) +
        #       automatically determine `auth-provider` based on extension use flags.
        text = ''
          auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
          guacd-hostname: localhost
          guacd-port: 4822
          enable-websocket: true
          ${cfg.propertiesExtraText}
        '';
      };

  userMappingFilePath = if cfg.userMappingText != null
    then builtins.toFile "user-mapping.xml" cfg.userMappingText
    else if cfg.userMappingFile != null
      then cfg.userMappingFile
      else pkgs.writeTextFile {
        name = "user-mapping.xml";
        # Empty file by default.
        text = "";
      };

in

{
  options = {
    services.guacamole = {
      enable = mkOption {
        description = "Enable guacamole";
        default = false;
        type = types.bool;
      };
      user = mkOption {
        description = "User account under which guacd runs.";
        default = "guacamole";
        type = types.str;
      };
      group = mkOption {
        description = "Group account under which guacd runs.";
        default = "guacamole";
        type = types.str;
      };

      propertiesText = mkOption {
        description = ''
          Content of <filename>guacamole.properties</filename> as specified
          in the docs. Note that this is mutually exclusive
          with <literal>propertiesFile</literal> and
          <literal>propertiesExtraText</literal>.
        '';
        default = null;
        example = ''
          auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
          guacd-hostname: localhost
          guacd-port: 4822
          enable-websocket: true
        '';
        type = types.nullOr types.lines;
      };

      propertiesExtraText = mkOption {
        description = ''
          Content appended to <filename>guacamole.properties</filename> once
          any default or structured content has been written.
          Note that this is mutually exclusive
          with <literal>propertiesFile</literal> and
          <literal>propertiesText</literal> in that if
          either is defined, this extra text won't be considered/appended.
        '';
        default = "";
        example = ''
          postgresql-hostname: localhost
          postgresql-port: 5432
          postgresql-database: guacamole_db
          postgresql-username: guacamole_user
          postgresql-password: changeme
          postgresql-default-max-connections: 1
          postgresql-default-max-group-connections: 1
        '';
        type = types.lines;
      };

      propertiesFile = mkOption {
        description = ''
          Path to <filename>guacamole.properties</filename> file as specified
          in the docs. Note that this is mutually exclusive
          with <literal>propertiesText</literal> and
          <literal>propertiesExtraText</literal>.
        '';
        default = null;
        example = "/var/tomcat/webapp/guac/guacamole.properties";
        type = types.nullOr (types.either types.path types.str);
      };

      userMappingText = mkOption {
        description = ''
          Content of <filename>user-mapping.xml</filename> as specified
          in the docs. Note that this is mutually exclusive
          with <literal>userMappingFile</literal>.
        '';
        default = null;
        example = ''
          <user-mapping>
              <authorize username="user"
                  password="pw">
          	    <connection name="example.com">
                      <protocol>ssh</protocol>
                      <param name="username">root</param>
                      <param name="hostname">localhost</param>
                      <param name="port">22</param>
                  </connection>
                  <connection name="another">
                      <protocol>rdp</protocol>
                      <param name="security">any</param>
                      <param name="username">root</param>
                      <param name="hostname">localhost</param>
                      <param name="port">3389</param>
                  </connection>
              </authorize>
          </user-mapping>
        '';
        type = types.nullOr types.lines;
      };

      userMappingFile = mkOption {
        description = ''
          Path to <filename>user-mapping.xml</filename> file as specified
          in the docs. Note that this is mutually exclusive
          with <literal>userMappingText</literal>.
        '';
        default = null;
        example = "/var/tomcat/webapp/guac/user-mapping.xml";
        type = types.nullOr (types.either types.path types.str);
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.guacd = {
      description = "Guacamole Proxy Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StandardOutput = "journal+console";
        StandardError = "journal+console";
        SyslogIdentifier = "guacd.service";
        Type = "simple";
        PermissionsStartOnly = true;
        # Someone with better tomcat experience needs to clean this up.
        ExecStartPre = pkgs.writeScript "guacd-prestart.sh" ''
          #!${pkgs.bash}/bin/bash
          set -euf -o pipefail
          mkdir -p ${homePath}
          if ! test -e "${propertiesFilePath}"; then
            1>&2 echo "<3>ERROR: The \"propertiesFilePath=${propertiesFilePath}\" file does not exist."
            exit 1
          fi
          ln -snfL ${propertiesFilePath} ${homePropertiesFilePath}
          if ! test -e "${userMappingFilePath}"; then
            1>&2 echo "<3>ERROR: \"userMappingFilePath=${userMappingFilePath}\" file does not exist."
            exit 1
          fi
          ln -snfL ${userMappingFilePath} ${homeUserMappingFilePath}
          ln -snfL -T ${homeExtensionsDir}/extensions ${homePath}/extensions
          chown ${config.services.tomcat.user}:${config.services.tomcat.group} ${homePath} -R
        '';
        ExecStart = "${guacamoleServer}/bin/guacd -f -L debug";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    services.tomcat = {
      enable = true;
      webapps = [ tomcatWebappDir ];
      commonLibs = [ "${tomcatCommonLibDir}" ];
    };

    systemd.services.tomcat.serviceConfig.Environment = ["GUACAMOLE_HOME=${homePath}" ];

    users.users = optionalAttrs (cfg.user == "guacamole") (singleton {
      name = cfg.user;
      group = cfg.group;
      uid = uid;
    });

    users.groups = optionalAttrs (cfg.group == "guacamole") (singleton {
      name = cfg.group;
      gid = gid;
    });

    assertions = [
      { assertion = (
            !(builtins.all (value: value != null) [cfg.propertiesText cfg.propertiesFile]) &&
            (!(builtins.any (value: value != null) [cfg.propertiesText cfg.propertiesFile]) ||
            "" == cfg.propertiesExtraText)
        );
        message = ''
          The following are mutually exclusive:
          <literal>propertiesText</literal>,
          <literal>propertiesFile</literal>.
          Also, if any is set, <literal>propertiesExtraText</literal> won't
          be considered, so we check it was left empty.
        '';
      }
      { assertion = (
          !(builtins.all (value: value != null) [cfg.userMappingText cfg.userMappingFile])
        );
        message = ''
          The following are mutually exclusive:
          <literal>userMappingText</literal>,
          <literal>userMappingFile</literal>.
        '';
      }
    ];
  };
}
