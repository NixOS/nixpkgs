{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.icingaweb2;
  fpm = config.services.phpfpm.pools.${poolName};
  poolName = "icingaweb2";

  defaultConfig = {
    global = {
      module_path = "${pkgs.icingaweb2}/modules";
    };
  };
in {
  meta.maintainers = with maintainers; [ das_j ];

  options.services.icingaweb2 = with types; {
    enable = mkEnableOption "the icingaweb2 web interface";

    pool = mkOption {
      type = str;
      default = poolName;
      description = ''
         Name of existing PHP-FPM pool that is used to run Icingaweb2.
         If not specified, a pool will automatically created with default values.
      '';
    };

    libraryPaths = mkOption {
      type = attrsOf package;
      default = { };
      description = ''
        Libraries to add to the Icingaweb2 library path.
        The name of the attribute is the name of the library, the value
        is the package to add.
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
      example = literalExpression ''
        {
          "snow" = icingaweb2Modules.theme-snow;
        }
      '';
      description = ''
        Name-package attrset of Icingaweb 2 modules packages to enable.

        If you enable modules manually (e.g. via the web ui), they will not be touched.
      '';
    };

    generalConfig = mkOption {
      type = nullOr attrs;
      default = null;
      example = {
        general = {
          showStacktraces = 1;
          config_resource = "icingaweb_db";
        };
        logging = {
          log = "syslog";
          level = "CRITICAL";
        };
      };
      description = ''
        config.ini contents.
        Will automatically be converted to a .ini file.
        If you don't set global.module_path, the module will take care of it.

        If the value is null, no config.ini is created and you can
        modify it manually (e.g. via the web interface).
        Note that you need to update module_path manually.
      '';
    };

    resources = mkOption {
      type = nullOr attrs;
      default = null;
      example = {
        icingaweb_db = {
          type = "db";
          db = "mysql";
          host = "localhost";
          username = "icingaweb2";
          password = "icingaweb2";
          dbname = "icingaweb2";
        };
      };
      description = ''
        resources.ini contents.
        Will automatically be converted to a .ini file.

        If the value is null, no resources.ini is created and you can
        modify it manually (e.g. via the web interface).
        Note that if you set passwords here, they will go into the nix store.
      '';
    };

    authentications = mkOption {
      type = nullOr attrs;
      default = null;
      example = {
        icingaweb = {
          backend = "db";
          resource = "icingaweb_db";
        };
      };
      description = ''
        authentication.ini contents.
        Will automatically be converted to a .ini file.

        If the value is null, no authentication.ini is created and you can
        modify it manually (e.g. via the web interface).
      '';
    };

    groupBackends = mkOption {
      type = nullOr attrs;
      default = null;
      example = {
        icingaweb = {
          backend = "db";
          resource = "icingaweb_db";
        };
      };
      description = ''
        groups.ini contents.
        Will automatically be converted to a .ini file.

        If the value is null, no groups.ini is created and you can
        modify it manually (e.g. via the web interface).
      '';
    };

    roles = mkOption {
      type = nullOr attrs;
      default = null;
      example = {
        Administrators = {
          users = "admin";
          permissions = "*";
        };
      };
      description = ''
        roles.ini contents.
        Will automatically be converted to a .ini file.

        If the value is null, no roles.ini is created and you can
        modify it manually (e.g. via the web interface).
      '';
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools = mkIf (cfg.pool == "${poolName}") {
      ${poolName} = {
        user = "icingaweb2";
        phpEnv = {
          ICINGAWEB_LIBDIR = toString (pkgs.linkFarm "icingaweb2-libdir" (mapAttrsToList (name: path: { inherit name path; }) cfg.libraryPaths));
        };
        phpPackage = pkgs.php.withExtensions ({ enabled, all }: [ all.imagick ] ++ enabled);
        phpOptions = ''
          date.timezone = "${cfg.timezone}"
        '';
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 10;
        };
      };
    };

    services.icingaweb2.libraryPaths = {
      ipl = pkgs.icingaweb2-ipl;
      thirdparty = pkgs.icingaweb2-thirdparty;
    };

    systemd.services."phpfpm-${poolName}".serviceConfig.ReadWritePaths = [ "/etc/icingaweb2" ];

    services.nginx = {
      enable = true;
      virtualHosts = mkIf (cfg.virtualHost != null) {
        ${cfg.virtualHost} = {
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
            fastcgi_pass unix:${fpm.socket};
            fastcgi_param SCRIPT_FILENAME ${pkgs.icingaweb2}/public/index.php;
          '';
        };
      };
    };

    # /etc/icingaweb2
    environment.etc = let
      doModule = name: optionalAttrs (cfg.modules.${name}.enable) { "icingaweb2/enabledModules/${name}".source = "${pkgs.icingaweb2}/modules/${name}"; };
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
      // optionalAttrs (cfg.generalConfig != null) { "icingaweb2/config.ini".text = generators.toINI {} (defaultConfig // cfg.generalConfig); }
      // optionalAttrs (cfg.resources != null) { "icingaweb2/resources.ini".text = generators.toINI {} cfg.resources; }
      // optionalAttrs (cfg.authentications != null) { "icingaweb2/authentication.ini".text = generators.toINI {} cfg.authentications; }
      // optionalAttrs (cfg.groupBackends != null) { "icingaweb2/groups.ini".text = generators.toINI {} cfg.groupBackends; }
      // optionalAttrs (cfg.roles != null) { "icingaweb2/roles.ini".text = generators.toINI {} cfg.roles; };

    # User and group
    users.groups.icingaweb2 = {};
    users.users.icingaweb2 = {
      description = "Icingaweb2 service user";
      group = "icingaweb2";
      isSystemUser = true;
    };
  };
}
