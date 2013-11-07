# Disnix server
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.disnix;

  dysnomia = pkgs.dysnomia.override (origArgs: {
    enableApacheWebApplication = config.services.httpd.enable;
    enableAxis2WebService = config.services.tomcat.axis2.enable;
    enableEjabberdDump = config.services.ejabberd.enable;
    enableMySQLDatabase = config.services.mysql.enable;
    enablePostgreSQLDatabase = config.services.postgresql.enable;
    enableSubversionRepository = config.services.svnserve.enable;
    enableTomcatWebApplication = config.services.tomcat.enable;
    enableMongoDatabase = config.services.mongodb.enable;
  });
in

{

  ###### interface

  options = {

    services.disnix = {

      enable = mkOption {
        default = false;
        description = "Whether to enable Disnix";
      };

      useWebServiceInterface = mkOption {
        default = false;
        description = "Whether to enable the DisnixWebService interface running on Apache Tomcat";
      };

      publishInfrastructure = {
        enable = mkOption {
          default = false;
          description = "Whether to publish capabilities/properties of this machine in as attributes in the infrastructure option";
        };

        enableAuthentication = mkOption {
          default = false;
          description = "Whether to publish authentication credentials through the infrastructure attribute (not recommended in combination with Avahi)";
        };
      };

      infrastructure = mkOption {
        default = {};
        description = "List of name value pairs containing properties for the infrastructure model";
      };

      publishAvahi = mkOption {
        default = false;
        description = "Whether to publish capabilities/properties as a Disnix service through Avahi";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.disnix ] ++ optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.disnix ];

    services.avahi.enable = cfg.publishAvahi;

    services.tomcat.enable = cfg.useWebServiceInterface;
    services.tomcat.extraGroups = [ "disnix" ];
    services.tomcat.javaOpts = "${optionalString cfg.useWebServiceInterface "-Djava.library.path=${pkgs.libmatthew_java}/lib/jni"} ";
    services.tomcat.sharedLibs = optional cfg.useWebServiceInterface "${pkgs.DisnixWebService}/share/java/DisnixConnection.jar"
                                 ++ optional cfg.useWebServiceInterface "${pkgs.dbus_java}/share/java/dbus.jar";
    services.tomcat.webapps = optional cfg.useWebServiceInterface pkgs.DisnixWebService;

    users.extraGroups = singleton
      { name = "disnix";
        gid = config.ids.gids.disnix;
      };

    services.disnix.infrastructure =
      optionalAttrs (cfg.publishInfrastructure.enable)
      ( { hostname = config.networking.hostName;
          #targetHost = config.deployment.targetHost;
          system = if config.nixpkgs.system == "" then builtins.currentSystem else config.nixpkgs.system;
          
          supportedTypes = (import "${pkgs.stdenv.mkDerivation {
            name = "supportedtypes";
            buildCommand = ''
              ( echo -n "[ "
                cd ${dysnomia}/libexec/dysnomia
                for i in *
                do
                    echo -n "\"$i\" "
                done
                echo -n " ]") > $out
            '';
          }}");
        }
        #// optionalAttrs (cfg.useWebServiceInterface) { targetEPR = "http://${config.deployment.targetHost}:8080/DisnixWebService/services/DisnixWebService"; }
        // optionalAttrs (config.services.httpd.enable) { documentRoot = config.services.httpd.documentRoot; }
        // optionalAttrs (config.services.mysql.enable) { mysqlPort = config.services.mysql.port; }
        // optionalAttrs (config.services.tomcat.enable) { tomcatPort = 8080; }
        // optionalAttrs (config.services.svnserve.enable) { svnBaseDir = config.services.svnserve.svnBaseDir; }
        // optionalAttrs (cfg.publishInfrastructure.enableAuthentication) (
          optionalAttrs (config.services.mysql.enable) { mysqlUsername = "root"; mysqlPassword = builtins.readFile config.services.mysql.rootPassword; })
        )
    ;

    services.disnix.publishInfrastructure.enable = cfg.publishAvahi;

    jobs = {
      disnix =
        { description = "Disnix server";
        
          wantedBy = [ "multi-user.target" ];
          after = [ "dbus.service" ]
            ++ optional config.services.httpd.enable "httpd.service"
            ++ optional config.services.mysql.enable "mysql.service"
            ++ optional config.services.tomcat.enable "tomcat.service"
            ++ optional config.services.svnserve.enable "svnserve.service"
            ++ optional config.services.mongodb.enable "mongodb.service";

          restartIfChanged = false;
          
          path = [ pkgs.nix pkgs.disnix pkgs.dysnomia ];
          
          environment = {
            HOME = "/root";
          };

          exec = "disnix-service";
        };
    } // optionalAttrs cfg.publishAvahi {
      disnixAvahi =
        { description = "Disnix Avahi publisher";

          startOn = "started avahi-daemon";

          exec =
          ''
            ${pkgs.avahi}/bin/avahi-publish-service disnix-${config.networking.hostName} _disnix._tcp 22 \
              "mem=$(grep 'MemTotal:' /proc/meminfo | sed -e 's/kB//' -e 's/MemTotal://' -e 's/ //g')" \
              ${concatMapStrings (infrastructureAttrName:
                let infrastructureAttrValue = getAttr infrastructureAttrName (cfg.infrastructure);
                in
                if builtins.isInt infrastructureAttrValue then
                ''${infrastructureAttrName}=${toString infrastructureAttrValue} \
                ''
                else
                ''${infrastructureAttrName}=\"${infrastructureAttrValue}\" \
                ''
                ) (attrNames (cfg.infrastructure))}
          '';
        };
    };
  };
}
