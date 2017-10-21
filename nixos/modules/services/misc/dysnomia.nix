{pkgs, lib, config, ...}:

with lib;

let
  cfg = config.dysnomia;
  
  printProperties = properties:
    concatMapStrings (propertyName:
      let
        property = properties."${propertyName}";
      in
      if isList property then "${propertyName}=(${lib.concatMapStrings (elem: "\"${toString elem}\" ") (properties."${propertyName}")})\n"
      else "${propertyName}=\"${toString property}\"\n"
    ) (builtins.attrNames properties);
  
  properties = pkgs.stdenv.mkDerivation {
    name = "dysnomia-properties";
    buildCommand = ''
      cat > $out << "EOF"
      ${printProperties cfg.properties}
      EOF
    '';
  };
  
  containersDir = pkgs.stdenv.mkDerivation {
    name = "dysnomia-containers";
    buildCommand = ''
      mkdir -p $out
      cd $out
      
      ${concatMapStrings (containerName:
        let
          containerProperties = cfg.containers."${containerName}";
        in
        ''
          cat > ${containerName} <<EOF
          ${printProperties containerProperties}
          type=${containerName}
          EOF
        ''
      ) (builtins.attrNames cfg.containers)}
    '';
  };
  
  linkMutableComponents = {containerName}:
    ''
      mkdir ${containerName}
      
      ${concatMapStrings (componentName:
        let
          component = cfg.components."${containerName}"."${componentName}";
        in
        "ln -s ${component} ${containerName}/${componentName}\n"
      ) (builtins.attrNames (cfg.components."${containerName}" or {}))}
    '';
  
  componentsDir = pkgs.stdenv.mkDerivation {
    name = "dysnomia-components";
    buildCommand = ''
      mkdir -p $out
      cd $out
      
      ${concatMapStrings (containerName:
        let
          components = cfg.components."${containerName}";
        in
        linkMutableComponents { inherit containerName; }
      ) (builtins.attrNames cfg.components)}
    '';
  };
in
{
  options = {
    dysnomia = {
      
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Dysnomia";
      };
      
      enableAuthentication = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to publish privacy-sensitive authentication credentials";
      };
      
      package = mkOption {
        type = types.path;
        description = "The Dysnomia package";
      };
      
      properties = mkOption {
        description = "An attribute set in which each attribute represents a machine property. Optionally, these values can be shell substitutions.";
        default = {};
      };
      
      containers = mkOption {
        description = "An attribute set in which each key represents a container and each value an attribute set providing its configuration properties";
        default = {};
      };
      
      components = mkOption {
        description = "An atttribute set in which each key represents a container and each value an attribute set in which each key represents a component and each value a derivation constructing its initial state";
        default = {};
      };
      
      extraContainerProperties = mkOption {
        description = "An attribute set providing additional container settings in addition to the default properties";
        default = {};
      };
      
      extraContainerPaths = mkOption {
        description = "A list of paths containing additional container configurations that are added to the search folders";
        default = [];
      };
      
      extraModulePaths = mkOption {
        description = "A list of paths containing additional modules that are added to the search folders";
        default = [];
      };
    };
  };
  
  config = mkIf cfg.enable {
  
    environment.etc = {
      "dysnomia/containers" = {
        source = containersDir;
      };
      "dysnomia/components" = {
        source = componentsDir;
      };
      "dysnomia/properties" = {
        source = properties;
      };
    };
    
    environment.variables = {
      DYSNOMIA_STATEDIR = "/var/state/dysnomia-nixos";
      DYSNOMIA_CONTAINERS_PATH = "${lib.concatMapStrings (containerPath: "${containerPath}:") cfg.extraContainerPaths}/etc/dysnomia/containers";
      DYSNOMIA_MODULES_PATH = "${lib.concatMapStrings (modulePath: "${modulePath}:") cfg.extraModulePaths}/etc/dysnomia/modules";
    };
    
    environment.systemPackages = [ cfg.package ];
    
    dysnomia.package = pkgs.dysnomia.override (origArgs: {
      enableApacheWebApplication = config.services.httpd.enable;
      enableAxis2WebService = config.services.tomcat.axis2.enable;
      enableEjabberdDump = config.services.ejabberd.enable;
      enableMySQLDatabase = config.services.mysql.enable;
      enablePostgreSQLDatabase = config.services.postgresql.enable;
      enableSubversionRepository = config.services.svnserve.enable;
      enableTomcatWebApplication = config.services.tomcat.enable;
      enableMongoDatabase = config.services.mongodb.enable;
    });
    
    dysnomia.properties = {
      hostname = config.networking.hostName;
      system = if config.nixpkgs.system == "" then builtins.currentSystem else config.nixpkgs.system;

      supportedTypes = (import "${pkgs.stdenv.mkDerivation {
        name = "supportedtypes";
        buildCommand = ''
          ( echo -n "[ "
            cd ${cfg.package}/libexec/dysnomia
            for i in *
            do
                echo -n "\"$i\" "
            done
            echo -n " ]") > $out
        '';
      }}");
    };
    
    dysnomia.containers = lib.recursiveUpdate ({
      process = {};
      wrapper = {};
    }
    // lib.optionalAttrs (config.services.httpd.enable) { apache-webapplication = {
      documentRoot = config.services.httpd.documentRoot;
    }; }
    // lib.optionalAttrs (config.services.tomcat.axis2.enable) { axis2-webservice = {}; }
    // lib.optionalAttrs (config.services.ejabberd.enable) { ejabberd-dump = {
      ejabberdUser = config.services.ejabberd.user;
    }; }
    // lib.optionalAttrs (config.services.mysql.enable) { mysql-database = {
        mysqlPort = config.services.mysql.port;
      } // lib.optionalAttrs cfg.enableAuthentication {
        mysqlUsername = "root";
        mysqlPassword = builtins.readFile (config.services.mysql.rootPassword);
      };
    }
    // lib.optionalAttrs (config.services.postgresql.enable && cfg.enableAuthentication) { postgresql-database = {
      postgresqlUsername = "root";
    }; }
    // lib.optionalAttrs (config.services.tomcat.enable) { tomcat-webapplication = {
      tomcatPort = 8080;
    }; }
    // lib.optionalAttrs (config.services.mongodb.enable) { mongo-database = {}; }
    // lib.optionalAttrs (config.services.svnserve.enable) { subversion-repository = {
      svnBaseDir = config.services.svnserve.svnBaseDir;
    }; }) cfg.extraContainerProperties;

    system.activationScripts.dysnomia = ''
      mkdir -p /etc/systemd-mutable/system
      if [ ! -f /etc/systemd-mutable/system/dysnomia.target ]
      then
          ( echo "[Unit]"
            echo "Description=Services that are activated and deactivated by Dysnomia"
            echo "After=final.target"
          ) > /etc/systemd-mutable/system/dysnomia.target
      fi
    '';
  };
}
