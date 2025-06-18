{
  config,
  lib,
  pkgs,
  ...
}:
let
  format = pkgs.formats.php { finalVariable = "config"; };

  cfg = config.services.filesender;
  simpleSamlCfg = config.services.simplesamlphp.filesender;
  fpm = config.services.phpfpm.pools.filesender;

  filesenderConfigDirectory = pkgs.runCommand "filesender-config" { } ''
    mkdir $out
    cp ${format.generate "config.php" cfg.settings} $out/config.php
  '';
in
{
  meta = {
    maintainers = with lib.maintainers; [ nhnn ];
    doc = ./filesender.md;
  };

  options.services.filesender = with lib; {
    enable = mkEnableOption "FileSender";
    package = mkPackageOption pkgs "filesender" { };
    user = mkOption {
      description = "User under which filesender runs.";
      type = types.str;
      default = "filesender";
    };
    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Create the PostgreSQL database and database user locally.
        '';
      };
      hostname = mkOption {
        type = types.str;
        default = "/run/postgresql";
        description = "Database hostname.";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Database port.";
      };
      name = mkOption {
        type = types.str;
        default = "filesender";
        description = "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = "filesender";
        description = "Database user.";
      };
      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/filesender-dbpassword";
        description = ''
          A file containing the password corresponding to
          [](#opt-services.filesender.database.user).
        '';
      };
    };
    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          site_url = mkOption {
            type = types.str;
            description = "Site URL. Used in emails, to build URLs for logging in, logging out, build URL for upload endpoint for web workers, to include scripts etc.";
          };
          admin = mkOption {
            type = types.commas;
            description = ''
              UIDs (as per the configured saml_uid_attribute) of FileSender administrators.
              Accounts with these UIDs can access the Admin page through the web UI.
            '';
          };
          admin_email = mkOption {
            type = types.commas;
            description = ''
              Email address of FileSender administrator(s).
              Emails regarding disk full etc. are sent here.
              You should use a role-address here.
            '';
          };
          storage_filesystem_path = mkOption {
            type = types.nullOr types.str;
            description = "When using storage type filesystem this is the absolute path to the file system where uploaded files are stored until they expire. Your FileSender storage root.";
          };
          log_facilities = mkOption {
            type = format.type;
            default = [ { type = "error_log"; } ];
            description = "Defines where FileSender logging is sent. You can sent logging to a file, to syslog or to the default PHP log facility (as configured through your webserver's PHP module). The directive takes an array of one or more logging targets. Logging can be sent to multiple targets simultaneously. Each logging target is a list containing the name of the logging target and a number of attributes which vary per log target. See below for the exact definiation of each log target.";
          };
        };
      };
      default = { };
      description = ''
        Configuration options used by FileSender.
        See [](https://docs.filesender.org/filesender/v2.0/admin/configuration/)
        for available options.
      '';
    };
    configureNginx = mkOption {
      type = types.bool;
      default = true;
      description = "Configure nginx as a reverse proxy for FileSender.";
    };
    localDomain = mkOption {
      type = types.str;
      example = "filesender.example.org";
      description = "The domain serving your FileSender instance.";
    };
    poolSettings = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };
      description = ''
        Options for FileSender's PHP pool. See the documentation on `php-fpm.conf` for details on configuration directives.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    services.simplesamlphp.filesender = {
      phpfpmPool = "filesender";
      localDomain = cfg.localDomain;
      settings.baseurlpath = lib.mkDefault "https://${cfg.localDomain}/saml";
    };

    services.phpfpm = {
      pools.filesender = {
        user = cfg.user;
        group = config.services.nginx.group;
        phpEnv = {
          FILESENDER_CONFIG_DIR = toString filesenderConfigDirectory;
          SIMPLESAMLPHP_CONFIG_DIR = toString simpleSamlCfg.configDir;
        };
        settings = {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolSettings;
      };
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts.${cfg.localDomain} = {
        root = "${cfg.package}/www";
        extraConfig = ''
          index index.php;
        '';
        locations = {
          "/".extraConfig = ''
            try_files $uri $uri/ /index.php?args;
          '';
          "~ [^/]\\.php(/|$)" = {
            extraConfig = ''
              fastcgi_split_path_info  ^(.+\.php)(/.+)$;
              fastcgi_pass  unix:${fpm.socket};
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_intercept_errors on;
              fastcgi_param PATH_INFO       $fastcgi_path_info;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
          };
          "~ /\\.".extraConfig = "deny all;";
        };
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.filesender.settings = lib.mkMerge [
      (lib.mkIf cfg.database.createLocally {
        db_host = "/run/postgresql";
        db_port = "5432";
        db_password = "."; # FileSender requires it even when on UNIX socket auth.
      })
      (lib.mkIf (!cfg.database.createLocally) {
        db_host = cfg.database.hostname;
        db_port = toString cfg.database.port;
        db_password = format.lib.mkRaw "file_get_contents('${cfg.database.passwordFile}')";
      })
      {
        site_url = lib.mkDefault "https://${cfg.localDomain}";
        db_type = "pgsql";
        db_username = cfg.database.user;
        db_database = cfg.database.name;
        "auth_sp_saml_simplesamlphp_url" = "/saml";
        "auth_sp_saml_simplesamlphp_location" = "${simpleSamlCfg.libDir}";
      }
    ];

    systemd.services.filesender-initdb = {
      description = "Init filesender DB";

      wantedBy = [
        "multi-user.target"
        "phpfpm-filesender.service"
      ];
      after = [ "postgresql.service" ];

      restartIfChanged = true;

      serviceConfig = {
        Environment = [
          "FILESENDER_CONFIG_DIR=${toString filesenderConfigDirectory}"
          "SIMPLESAMLPHP_CONFIG_DIR=${toString simpleSamlCfg.configDir}"
        ];
        Type = "oneshot";
        Group = config.services.nginx.group;
        User = "filesender";
        ExecStart = "${fpm.phpPackage}/bin/php ${cfg.package}/scripts/upgrade/database.php";
      };
    };

    users.extraUsers.filesender = lib.mkIf (cfg.user == "filesender") {
      home = "/var/lib/filesender";
      group = config.services.nginx.group;
      createHome = true;
      isSystemUser = true;
    };
  };
}
