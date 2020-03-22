{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.filesender;
  fpm = config.services.phpfpm.pools.filesender;
in {
  options.services.filesender = {
    enable = mkEnableOption "filesender";
    hostName = mkOption {
      type = types.str;
      description = "FQDN for the filesender instance";
      example = "filesender.mydomain.com";
    };
    home = mkOption {
      type = types.str;
      default = "/var/lib/filesender";
      description = "Storage path of Filesender.";
    };
    poolSettings = mkOption {
      type = with types; attrsOf str;
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };
      description = ''
        Options for filesender's PHP pool. See the documentation on <literal>php-fpm.conf</literal> for details on configuration directives.
      '';
    };
    # dbtype = mkOption {
    #   type = types.enum [ "pgsql" "mysql" ];
    #   default = "pgsql";
    #   description = "Database type.";
    # };
    # dbname = mkOption {
    #   type = types.nullOr types.str;
    #   default = "filesender";
    #   description = "Database name.";
    # };
    # dbuser = mkOption {
    #   type = types.nullOr types.str;
    #   default = "filesender";
    #   description = "Database user.";
    # };
    # dbpass = mkOption {
    #   type = types.nullOr types.str;
    #   default = null;
    #   description = ''
    #     Database password.  Use <literal>dbpassFile</literal> to avoid this
    #     being world-readable in the <literal>/nix/store</literal>.
    #   '';
    # };
    # dbpassFile = mkOption {
    #   type = types.nullOr types.str;
    #   default = null;
    #   description = ''
    #     The full path to a file that contains the database password.
    #   '';
    # };
    # dbhost = mkOption {
    #   type = types.nullOr types.str;
    #   default = "localhost";
    #   description = ''
    #     Database host.

    #     Note: for using Unix authentication with PostgreSQL, this should be
    #     set to <literal>/run/postgresql</literal>.
    #   '';
    # };
  };

  config = mkIf cfg.enable {

    systemd.services.filesender-setup = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-filesender.service" ];
      script = ''
        chown filesender:nginx -R ${cfg.home}
        mkdir -p ${cfg.home}/config
        mkdir -p ${cfg.home}/tmp
        mkdir -p ${cfg.home}/files
        mkdir -p ${cfg.home}/log
      '';
      serviceConfig.Type = "oneshot";
    };

    # Config is read in classes/utils/Config.class.php as:
    #
    # $main_config_file = FILESENDER_BASE.'/config/config.php';
    #
    # $config_file = FILESENDER_BASE.'/config/'.$virtualhost.'/config.php';
    #
    # So, how to handle this in NixOS??
    #
    # Patch Config.class.php so that it reads some environment variable instead
    # of FILESENDER_BASE if given. For instance, FILESENDER_CONFIG_DIR

    services.phpfpm = {
      pools.filesender = {
        user = "filesender";
        group = "nginx";
        phpEnv = {
          # FIXME/TODO: Write the config to nix store!!!
          FILESENDER_CONFIG_DIR = "${cfg.home}/config";
        };
        settings = {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
        } // cfg.poolSettings;
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.hostName}" = {
        # TODO: SSL stuff
        forceSSL = true;
        enableACME = true;
        root = "${pkgs.filesender}/www";
        locations = {
          "/" = {
            extraConfig = ''
              try_files $uri /index.php?args;
            '';
          };
          "~ [^/]\\.php(/|$)" = {
            extraConfig = ''
              fastcgi_split_path_info  ^(.+\.php)(/.+)$;
              fastcgi_pass  unix:${fpm.socket};
              include ${config.services.nginx.package}/conf/fastcgi.conf;
              fastcgi_intercept_errors on;
              fastcgi_param PATH_INFO       $fastcgi_path_info;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
          };
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "filesender" ];
      ensureUsers = [
        {
          name = "filesender";
          ensurePermissions = {
            "DATABASE filesender" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    users.extraUsers.filesender = {
      home = "${cfg.home}";
      # TODO: Should I use system UID defined in nixos/modules/misc/ids.nix?
      group = "nginx";
      createHome = true;
    };

  };
}
