{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.icingaweb2;
  poolName = "icingaweb2";
  phpfpmSocketName = "/var/run/phpfpm/${poolName}.sock";

  formatBool = b: if b then "1" else "0";

  configIni = let
    config = cfg.generalConfig;
  in ''
    [global]
    show_stacktraces = "${formatBool config.showStacktraces}"
    show_application_state_messages = "${formatBool config.showApplicationStateMessages}"
    module_path = "${pkgs.icingaweb2}/modules${optionalString (builtins.length config.modulePath > 0) ":${concatStringsSep ":" config.modulePath}"}"
    config_backend = "${config.configBackend}"
    ${optionalString (config.configBackend == "db") ''config_resource = "${config.configResource}"''}

    [logging]
    log = "${config.log}"
    ${optionalString (config.log != "none") ''level = "${config.logLevel}"''}
    ${optionalString (config.log == "php" || config.log == "syslog") ''application = "${config.logApplication}"''}
    ${optionalString (config.log == "syslog") ''facility = "${config.logFacility}"''}
    ${optionalString (config.log == "file") ''file = "${config.logFile}"''}

    [themes]
    default = "${config.themeDefault}"
    disabled = "${formatBool config.themeDisabled}"

    [authentication]
    ${optionalString (config.authDefaultDomain != null) ''default_domain = "${config.authDefaultDomain}"''}
  '';

  resourcesIni = concatStringsSep "\n" (mapAttrsToList (name: config: ''
    [${name}]
    type = "${config.type}"
    ${optionalString (config.type == "db") ''
      db = "${config.db}"
      host = "${config.host}"
      ${optionalString (config.port != null) ''port = "${toString config.port}"''}
      username = "${config.username}"
      password = "${config.password}"
      dbname = "${config.dbname}"
      ${optionalString (config.charset != null) ''charset = "${config.charset}"''}
      use_ssl = "${formatBool config.useSSL}"
      ${optionalString (config.sslCert != null) ''ssl_cert = "${config.sslCert}"''}
      ${optionalString (config.sslKey != null) ''ssl_cert = "${config.sslKey}"''}
      ${optionalString (config.sslCA != null) ''ssl_cert = "${config.sslCA}"''}
      ${optionalString (config.sslCApath != null) ''ssl_cert = "${config.sslCApath}"''}
      ${optionalString (config.sslCipher != null) ''ssl_cert = "${config.sslCipher}"''}
    ''}
    ${optionalString (config.type == "ldap") ''
      hostname = "${config.host}"
      ${optionalString (config.port != null) ''port = "${toString config.port}"''}
      root_dn = "${config.rootDN}"
      bind_dn = "${config.username}"
      bind_pw = "${config.password}"
      encryption = "${config.ldapEncryption}"
      timeout = "${toString config.ldapTimeout}"
    ''}
    ${optionalString (config.type == "ssh") ''
      user = "${config.username}"
      private_key = "${config.sshPrivateKey}"
    ''}

  '') cfg.resources);

  authenticationIni = concatStringsSep "\n" (mapAttrsToList (name: config: ''
    [${name}]
    backend = "${config.backend}"
    ${optionalString (config.domain != null) ''domain = "${config.domain}"''}
    ${optionalString (config.backend == "external" && config.externalStripRegex != null) ''strip_username_regexp = "${config.externalStripRegex}"''}
    ${optionalString (config.backend != "external") ''resource = "${config.resource}"''}
    ${optionalString (config.backend == "ldap" || config.backend == "msldap") ''
      ${optionalString (config.ldapUserClass != null) ''user_class = "${config.ldapUserClass}"''}
      ${optionalString (config.ldapUserNameAttr != null) ''user_name_attribute = "${config.ldapUserNameAttr}"''}
      ${optionalString (config.ldapFilter != null) ''filter = "${config.ldapFilter}"''}
    ''}
  '') cfg.authentications);

  groupsIni = concatStringsSep "\n" (mapAttrsToList (name: config: ''
    [${name}]
    backend = "${config.backend}"
    resource = "${config.resource}"
    ${optionalString (config.backend != "db") ''
      ${optionalString (config.ldapUserClass != null) ''user_class = "${config.ldapUserClass}"''}
      ${optionalString (config.ldapUserNameAttr != null) ''user_name_attribute = "${config.ldapUserNameAttr}"''}
      ${optionalString (config.ldapGroupClass != null) ''group_class = "${config.ldapGroupClass}"''}
      ${optionalString (config.ldapGroupNameAttr != null) ''group_name_attribute = "${config.ldapGroupNameAttr}"''}
      ${optionalString (config.ldapGroupFilter != null) ''group_filter = "${config.ldapGroupFilter}"''}
    ''}
    ${optionalString (config.backend == "msldap" && config.ldapNestedSearch) ''nested_group_search = "1"''}
  '') cfg.groupBackends);

  rolesIni = let
    optionalList = var: attribute: optionalString (builtins.length var > 0) ''${attribute} = "${concatStringsSep "," var}"'';
  in concatStringsSep "\n" (mapAttrsToList (name: config: ''
    [${name}]
    ${optionalList config.users "users"}
    ${optionalList config.groups "groups"}
    ${optionalList config.permissions "permissions"}
    ${optionalList config.permissions "permissions"}
    ${concatStringsSep "\n" (mapAttrsToList (key: value: optionalList value key) config.extraAssignments)}
  '') cfg.roles);

in {
  options.services.icingaweb2 = with types; {
    enable = mkEnableOption "the icingaweb2 web interface";

    pool = mkOption {
      type = str;
      default = "${poolName}";
      description = ''
         Name of existing PHP-FPM pool that is used to run Icingaweb2.
         If not specified, a pool will automatically created with default values.
      '';
    };

    virtualHost = mkOption {
      type = nullOr str;
      default = "icingaweb2";
      description = ''
        Name of the nginx virtualhost to use and setup. If null, no virtualhost is set up.
      '';
    };

    timezone = mkOption {
      type = str;
      default = "UTC";
      example = "Europe/Berlin";
      description = "PHP-compliant timezone specification";
    };

    modules = {
      doc.enable = mkEnableOption "the icingaweb2 doc module";
      migrate.enable = mkEnableOption "the icingaweb2 migrate module";
      setup.enable = mkEnableOption "the icingaweb2 setup module";
      test.enable = mkEnableOption "the icingaweb2 test module";
      translation.enable = mkEnableOption "the icingaweb2 translation module";
    };

    modulePackages = mkOption {
      type = attrsOf package;
      default = {};
      example = literalExample ''
        {
          "snow" = pkgs.icingaweb2Modules.theme-snow;
        }
      '';
      description = ''
        Name-package attrset of Icingaweb 2 modules packages to enable.

        If you enable modules manually (e.g. via the web ui), they will not be touched.
      '';
    };

    generalConfig = {
      mutable = mkOption {
        type = bool;
        default = false;
        description = ''
          Make config.ini mutable (e.g. via the web interface).
          Not that you need to update module_path manually.
        '';
      };

      showStacktraces = mkOption {
        type = bool;
        default = true;
        description = "Enable stack traces in the Web UI";
      };

      showApplicationStateMessages = mkOption {
        type = bool;
        default = true;
        description = "Enable application state messages in the Web UI";
      };

      modulePath = mkOption {
        type = listOf str;
        default = [];
        description = "List of additional module search paths";
      };

      configBackend = mkOption {
        type = enum [ "ini" "db" "none" ];
        default = "db";
        description = "Where to store user preferences";
      };

      configResource = mkOption {
        type = nullOr str;
        default = null;
        description = "Database resource where user preferences are stored (if they are stored in a database)";
      };

      log = mkOption {
        type = enum [ "syslog" "php" "file" "none" ];
        default = "syslog";
        description = "Logging target";
      };

      logLevel = mkOption {
        type = enum [ "ERROR" "WARNING" "INFO" "DEBUG" ];
        default = "ERROR";
        description = "Maximum logging level to emit";
      };

      logApplication = mkOption {
        type = str;
        default = "icingaweb2";
        description = "Application name to log under (syslog and php log)";
      };

      logFacility = mkOption {
        type = enum [ "user" "local0" "local1" "local2" "local3" "local4" "local5" "local6" "local7" ];
        default = "user";
        description = "Syslog facility to log to";
      };

      logFile = mkOption {
        type = str;
        default = "/var/log/icingaweb2/icingaweb2.log";
        description = "File to log to";
      };

      themeDefault = mkOption {
        type = str;
        default = "Icinga";
        description = "Name of the default theme";
      };

      themeDisabled = mkOption {
        type = bool;
        default = false;
        description = "Disallow users to change the theme";
      };

      authDefaultDomain = mkOption {
        type = nullOr str;
        default = null;
        description = "Domain for users logging in without a qualified domain";
      };
    };

    mutableResources = mkOption {
      type = bool;
      default = false;
      description = "Make resources.ini mutable (e.g. via the web interface)";
    };

    resources = mkOption {
      default = {};
      description = "Icingaweb 2 resources to define";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this resource";
          };

          type = mkOption {
            type = enum [ "db" "ldap" "ssh" ];
            default = "db";
            description = "Type of this resouce";
          };

          db = mkOption {
            type = enum [ "mysql" "pgsql" ];
            default = "mysql";
            description = "Type of this database resource";
          };

          host = mkOption {
            type = str;
            description = "Host to connect to";
          };

          port = mkOption {
            type = nullOr port;
            default = null;
            description = "Port to connect on";
          };

          username = mkOption {
            type = str;
            description = "Database or SSH user or LDAP bind DN to connect with";
          };

          password = mkOption {
            type = str;
            description = "Password for the database user or LDAP bind DN";
          };

          dbname = mkOption {
            type = str;
            description = "Name of the database to connect to";
          };

          charset = mkOption {
            type = nullOr str;
            default = null;
            example = "utf8";
            description = "Database character set to connect with";
          };

          useSSL = mkOption {
            type = nullOr bool;
            default = false;
            description = "Whether to connect to the database using SSL";
          };

          sslCert = mkOption {
            type = nullOr str;
            default = null;
            description = "The file path to the SSL certificate. Only available for the mysql database.";
          };

          sslKey = mkOption {
            type = nullOr str;
            default = null;
            description = "The file path to the SSL key. Only available for the mysql database.";
          };

          sslCA = mkOption {
            type = nullOr str;
            default = null;
            description = "The file path to the SSL certificate authority. Only available for the mysql database.";
          };

          sslCApath = mkOption {
            type = nullOr str;
            default = null;
            description = "The file path to the directory that contains the trusted SSL CA certificates in PEM format. Only available for the mysql database.";
          };

          sslCipher = mkOption {
            type = nullOr str;
            default = null;
            description = "A list of one or more permissible ciphers to use for SSL encryption, in a format understood by OpenSSL. Only available for the mysql database.";
          };

          rootDN = mkOption {
            type = str;
            description = "Root object of the LDAP tree";
          };

          ldapEncryption = mkOption {
            type = enum [ "none" "starttls" "ldaps" ];
            default = "none";
            description = "LDAP encryption to use";
          };

          ldapTimeout = mkOption {
            type = ints.positive;
            default = 5;
            description = "Connection timeout for every LDAP connection";
          };

          sshPrivateKey = mkOption {
            type = str;
            description = "The path to the private key of the user";
          };
        };
      }));
    };

    mutableAuthConfig = mkOption {
      type = bool;
      default = true;
      description = "Make authentication.ini mutable (e.g. via the web interface)";
    };

    authentications = mkOption {
      default = {};
      description = "Icingaweb 2 authentications to define";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this authentication";
          };

          backend = mkOption {
            type = enum [ "external" "ldap" "msldap" "db" ];
            default = "db";
            description = "The type of this authentication backend";
          };

          domain = mkOption {
            type = nullOr str;
            default = null;
            description = "Domain for domain-aware authentication";
          };

          externalStripRegex = mkOption {
            type = nullOr str;
            default = null;
            description = "Regular expression to strip off specific user name parts";
          };

          resource = mkOption {
            type = str;
            description = "Name of the database/LDAP resource";
          };

          ldapUserClass = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP user class";
          };

          ldapUserNameAttr = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP attribute which contains the username";
          };

          ldapFilter = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP search filter";
          };
        };
      }));
    };

    mutableGroupsConfig = mkOption {
      type = bool;
      default = true;
      description = "Make groups.ini mutable (e.g. via the web interface)";
    };

    groupBackends = mkOption {
      default = {};
      description = "Icingaweb 2 group backends to define";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this group backend";
          };

          backend = mkOption {
            type = enum [ "ldap" "msldap" "db" ];
            default = "db";
            description = "The type of this group backend";
          };

          resource = mkOption {
            type = str;
            description = "Name of the database/LDAP resource";
          };

          ldapUserClass = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP user class";
          };

          ldapUserNameAttr = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP attribute which contains the username";
          };

          ldapGroupClass = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP group class";
          };

          ldapGroupNameAttr = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP attribute which contains the groupname";
          };

          ldapGroupFilter = mkOption {
            type = nullOr str;
            default = null;
            description = "LDAP group search filter";
          };

          ldapNestedSearch = mkOption {
            type = bool;
            default = false;
            description = "Enable nested group search in Active Directory based on the user";
          };
        };
      }));
    };

    mutableRolesConfig = mkOption {
      type = bool;
      default = true;
      description = "Make roles.ini mutable (e.g. via the web interface)";
    };

    roles = mkOption {
      default = {};
      description = "Icingaweb 2 roles to define";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this role";
          };

          users = mkOption {
            type = listOf str;
            default = [];
            description = "List of users that are assigned to the role";
          };

          groups = mkOption {
            type = listOf str;
            default = [];
            description = "List of groups that are assigned to the role";
          };

          permissions = mkOption {
            type = listOf str;
            default = [];
            example = [ "application/share/navigation" "config/*" ];
            description = "The permissions to grant";
          };

          extraAssignments = mkOption {
            type = attrsOf (listOf str);
            default = {};
            example = { "monitoring/blacklist/properties" = [ "sla" "customer"]; };
            description = "Additional assignments of this role";
          };
        };
      }));
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.poolConfigs = mkIf (cfg.pool == "${poolName}") {
      "${poolName}" = ''
        listen = "${phpfpmSocketName}"
        listen.owner = nginx
        listen.group = nginx
        listen.mode = 0600
        user = icingaweb2
        pm = dynamic
        pm.max_children = 75
        pm.start_servers = 2
        pm.min_spare_servers = 2
        pm.max_spare_servers = 10
      '';
    };

    services.phpfpm.phpOptions = mkIf (cfg.pool == "${poolName}")
      ''
        extension = ${pkgs.phpPackages.imagick}/lib/php/extensions/imagick.so
        date.timezone = "${cfg.timezone}"
      '';

    systemd.services."phpfpm-${poolName}".serviceConfig.ReadWritePaths = [ "/etc/icingaweb2" ];

    services.nginx = {
      enable = true;
      virtualHosts = mkIf (cfg.virtualHost != null) {
        "${cfg.virtualHost}" = {
          root = "${pkgs.icingaweb2}/public";

          extraConfig = ''
            index index.php;
            try_files $1 $uri $uri/ /index.php$is_args$args;
          '';

          locations."~ ..*/.*.php$".extraConfig = ''
            return 403;
          '';

          locations."~ ^/index.php(.*)$".extraConfig = ''
            fastcgi_intercept_errors on;
            fastcgi_index index.php;
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${phpfpmSocketName};
            fastcgi_param SCRIPT_FILENAME ${pkgs.icingaweb2}/public/index.php;
          '';
        };
      };
    };

    # /etc/icingaweb2
    environment.etc = let
      doModule = name: optionalAttrs (cfg.modules."${name}".enable) (nameValuePair "icingaweb2/enabledModules/${name}" { source = "${pkgs.icingaweb2}/modules/${name}"; });
    in {}
      # Module packages
      // (mapAttrs' (k: v: nameValuePair "icingaweb2/enabledModules/${k}" { source = v; }) cfg.modulePackages)
      # Built-in modules
      // doModule "doc"
      // doModule "migrate"
      // doModule "setup"
      // doModule "test"
      // doModule "translation"
      # Configs
      // optionalAttrs (!cfg.generalConfig.mutable) { "icingaweb2/config.ini".text = configIni; }
      // optionalAttrs (!cfg.mutableResources) { "icingaweb2/resources.ini".text = resourcesIni; }
      // optionalAttrs (!cfg.mutableAuthConfig) { "icingaweb2/authentication.ini".text = authenticationIni; }
      // optionalAttrs (!cfg.mutableGroupsConfig) { "icingaweb2/groups.ini".text = groupsIni; }
      // optionalAttrs (!cfg.mutableRolesConfig) { "icingaweb2/roles.ini".text = rolesIni; };

    # User and group
    users.groups.icingaweb2 = {};
    users.users.icingaweb2 = {
      description = "Icingaweb2 service user";
      group = "icingaweb2";
      isSystemUser = true;
    };
  };
}
