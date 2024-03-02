{ config, pkgs, lib, ... }:

let
  cfg = config.services.anuko-time-tracker;
  configFile = let
    smtpPassword = if cfg.settings.email.smtpPasswordFile == null
                   then "''"
                   else "trim(file_get_contents('${cfg.settings.email.smtpPasswordFile}'))";

  in pkgs.writeText "config.php" ''
    <?php
    // Set include path for PEAR and its modules, which we include in the distribution.
    // Updated for the correct location in the nix store.
    set_include_path('${cfg.package}/WEB-INF/lib/pear' . PATH_SEPARATOR . get_include_path());
    define('DSN', 'mysqli://${cfg.database.user}@${cfg.database.host}/${cfg.database.name}?charset=utf8mb4');
    define('MULTIORG_MODE', ${lib.boolToString cfg.settings.multiorgMode});
    define('EMAIL_REQUIRED', ${lib.boolToString cfg.settings.emailRequired});
    define('WEEKEND_START_DAY', ${toString cfg.settings.weekendStartDay});
    define('FORUM_LINK', '${cfg.settings.forumLink}');
    define('HELP_LINK', '${cfg.settings.helpLink}');
    define('SENDER', '${cfg.settings.email.sender}');
    define('MAIL_MODE', '${cfg.settings.email.mode}');
    define('MAIL_SMTP_HOST', '${toString cfg.settings.email.smtpHost}');
    define('MAIL_SMTP_PORT', '${toString cfg.settings.email.smtpPort}');
    define('MAIL_SMTP_USER', '${cfg.settings.email.smtpUser}');
    define('MAIL_SMTP_PASSWORD', ${smtpPassword});
    define('MAIL_SMTP_AUTH', ${lib.boolToString cfg.settings.email.smtpAuth});
    define('MAIL_SMTP_DEBUG', ${lib.boolToString cfg.settings.email.smtpDebug});
    define('DEFAULT_CSS', 'default.css');
    define('RTL_CSS', 'rtl.css'); // For right to left languages.
    define('LANG_DEFAULT', '${cfg.settings.defaultLanguage}');
    define('CURRENCY_DEFAULT', '${cfg.settings.defaultCurrency}');
    define('EXPORT_DECIMAL_DURATION', ${lib.boolToString cfg.settings.exportDecimalDuration});
    define('REPORT_FOOTER', ${lib.boolToString cfg.settings.reportFooter});
    define('AUTH_MODULE', 'db');
  '';
  package = pkgs.stdenv.mkDerivation rec {
    pname = "anuko-time-tracker";
    inherit (src) version;
    src = cfg.package;
    installPhase = ''
      mkdir -p $out
      cp -r * $out/

      # Link config file
      ln -s ${configFile} $out/WEB-INF/config.php

      # Link writable templates_c directory
      rm -rf $out/WEB-INF/templates_c
      ln -s ${cfg.dataDir}/templates_c $out/WEB-INF/templates_c

      # Remove unsafe dbinstall.php
      rm -f $out/dbinstall.php
    '';
  };
in
{
  options.services.anuko-time-tracker = {
    enable = lib.mkEnableOption (lib.mdDoc "Anuko Time Tracker");

    package = lib.mkPackageOption pkgs "anuko-time-tracker" {};

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc "Create the database and database user locally.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "Database host.";
        default = "localhost";
      };

      name = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "Database name.";
        default = "anuko_time_tracker";
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "Database username.";
        default = "anuko_time_tracker";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = lib.mdDoc "Database user password file.";
        default = null;
      };
    };

    poolConfig = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [ lib.types.str lib.types.int lib.types.bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = lib.mdDoc ''
        Options for Anuko Time Tracker's PHP-FPM pool.
      '';
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default =
        if config.networking.domain != null
        then config.networking.fqdn
        else config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.fqdn";
      example = "anuko.example.com";
      description = lib.mdDoc ''
        The hostname to serve Anuko Time Tracker on.
      '';
    };

    nginx = lib.mkOption {
      type = lib.types.submodule (
        lib.recursiveUpdate
          (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {}
      );
      default = {};
      example = lib.literalExpression ''
        {
          serverAliases = [
            "anuko.''${config.networking.domain}"
          ];

          # To enable encryption and let let's encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = lib.mdDoc ''
        With this option, you can customize the Nginx virtualHost settings.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/anuko-time-tracker";
      description = lib.mdDoc "Default data folder for Anuko Time Tracker.";
      example = "/mnt/anuko-time-tracker";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "anuko_time_tracker";
      description = lib.mdDoc "User under which Anuko Time Tracker runs.";
    };

    settings = {
      multiorgMode = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Defines whether users see the Register option in the menu of Time Tracker that allows them
          to self-register and create new organizations (top groups).
        '';
      };

      emailRequired = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc "Defines whether an email is required for new registrations.";
      };

      weekendStartDay = lib.mkOption {
        type = lib.types.int;
        default = 6;
        description = lib.mdDoc ''
          This option defines which days are highlighted with weekend color.
          6 means Saturday. For Saudi Arabia, etc. set it to 4 for Thursday and Friday to be
          weekend days.
        '';
      };

      forumLink = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "Forum link from the main menu.";
        default = "https://www.anuko.com/forum/viewforum.php?f=4";
      };

      helpLink = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "Help link from the main menu.";
        default = "https://www.anuko.com/time-tracker/user-guide/index.htm";
      };

      email = {
        sender = lib.mkOption {
          type = lib.types.str;
          description = lib.mdDoc "Default sender for mail.";
          default = "Anuko Time Tracker <bounces@example.com>";
        };

        mode = lib.mkOption {
          type = lib.types.str;
          description = lib.mdDoc "Mail sending mode. Can be 'mail' or 'smtp'.";
          default = "smtp";
        };

        smtpHost = lib.mkOption {
          type = lib.types.str;
          description = lib.mdDoc "MTA hostname.";
          default = "localhost";
        };

        smtpPort = lib.mkOption {
          type = lib.types.int;
          description = lib.mdDoc "MTA port.";
          default = 25;
        };

        smtpUser = lib.mkOption {
          type = lib.types.str;
          description = lib.mdDoc "MTA authentication username.";
          default = "";
        };

        smtpAuth = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = lib.mdDoc "MTA requires authentication.";
        };

        smtpPasswordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/var/lib/anuko-time-tracker/secrets/smtp-password";
          description = lib.mdDoc ''
            Path to file containing the MTA authentication password.
          '';
        };

        smtpDebug = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = lib.mdDoc "Debug mail sending.";
        };
      };

      defaultLanguage = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          Defines Anuko Time Tracker default language. It is used on Time Tracker login page.
          After login, a language set for user group is used.
          Empty string means the language is defined by user browser.
        '';
        default = "";
        example = "nl";
      };

      defaultCurrency = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          Defines a default currency symbol for new groups.
          Use €, £, a more specific dollar like US$, CAD, etc.
        '';
        default = "$";
        example = "€";
      };

      exportDecimalDuration = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Defines whether time duration values are decimal in CSV and XML data
          exports (1.25 vs 1:15).
        '';
      };

      reportFooter = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc "Defines whether to use a footer on reports.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = ''
          <option>services.anuko-time-tracker.database.passwordFile</option> cannot be specified if
          <option>services.anuko-time-tracker.database.createLocally</option> is set to true.
        '';
      }
      {
        assertion = cfg.settings.email.smtpAuth -> (cfg.settings.email.smtpPasswordFile != null);
        message = ''
          <option>services.anuko-time-tracker.settings.email.smtpPasswordFile</option> needs to be set if
          <option>services.anuko-time-tracker.settings.email.smtpAuth</option> is enabled.
        '';
      }
    ];

    services.phpfpm = {
      pools.anuko-time-tracker = {
        inherit (cfg) user;
        group = config.services.nginx.group;
        settings = {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolConfig;
      };
    };

    services.nginx = {
      enable = lib.mkDefault true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts."${cfg.hostname}" = lib.mkMerge [
        cfg.nginx
        {
          root = lib.mkForce "${package}";
          locations = {
            "/".index = "index.php";
            "~ [^/]\\.php(/|$)" = {
              extraConfig = ''
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                fastcgi_pass unix:${config.services.phpfpm.pools.anuko-time-tracker.socket};
              '';
            };
          };
        }
      ];
    };

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = {
          "${cfg.database.name}.*" = "ALL PRIVILEGES";
        };
      }];
    };

    systemd = {
      services = {
        anuko-time-tracker-setup-database = lib.mkIf cfg.database.createLocally {
          description = "Set up Anuko Time Tracker database";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          wantedBy = [ "phpfpm-anuko-time-tracker.service" ];
          after = [ "mysql.service" ];
          script =
            let
              mysql = "${config.services.mysql.package}/bin/mysql";
            in
            ''
              if [ ! -f ${cfg.dataDir}/.dbexists ]; then
                # Load database schema provided with package
                ${mysql} ${cfg.database.name} < ${cfg.package}/mysql.sql

                touch ${cfg.dataDir}/.dbexists
              fi
            '';
        };
      };
      tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 ${cfg.user} ${config.services.nginx.group} -"
        "d ${cfg.dataDir}/templates_c 0750 ${cfg.user} ${config.services.nginx.group} -"
      ];
    };

    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = config.services.nginx.group;
    };
  };

  meta.maintainers = with lib.maintainers; [ michaelshmitty ];
}
