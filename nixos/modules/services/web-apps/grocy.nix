{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.grocy;
in
{
  options.services.grocy = {
    enable = mkEnableOption "grocy";

    package = mkPackageOption pkgs "grocy" { };

    hostName = mkOption {
      type = types.str;
      description = ''
        FQDN for the grocy instance.
      '';
    };

    nginx.enableSSL = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to enable SSL (with ACME and let's encrypt)
        for the grocy vhost.
      '';
    };

    phpfpm.settings = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          int
          str
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "listen.owner" = config.services.nginx.user;
        "catch_workers_output" = true;
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };
      defaultText = lib.literalExpression ''
        {
          "pm" = "dynamic";
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
          "listen.owner" = config.services.nginx.user;
          "catch_workers_output" = true;
          "pm.max_children" = "32";
          "pm.start_servers" = "2";
          "pm.min_spare_servers" = "2";
          "pm.max_spare_servers" = "4";
          "pm.max_requests" = "500";
        }
      '';

      description = ''
        Options for grocy's PHPFPM pool.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/grocy";
      description = ''
        Home directory of the `grocy` user which contains
        the application's state.
      '';
    };

    settings = {
      currency = mkOption {
        type = types.str;
        default = "USD";
        example = "EUR";
        description = ''
          ISO 4217 code for the currency to display.
        '';
      };

      culture = mkOption {
        type = types.enum [
          "bg_BG"
          "ca"
          "cs"
          "da"
          "de"
          "el_GR"
          "en"
          "en_GB"
          "es"
          "et_EE"
          "fi"
          "fr"
          "he_IL"
          "hu"
          "it"
          "ja"
          "ko_KR"
          "lt"
          "nl"
          "no"
          "pl"
          "pt_BR"
          "pt_PT"
          "ro_RO"
          "ru"
          "sk_SK"
          "sl"
          "sv_SE"
          "ta"
          "tr"
          "uk"
          "zh_CN"
          "zh_TW"
        ];
        default = "en";
        description = ''
          Display language of the frontend.
        '';
      };

      calendar = {
        showWeekNumber = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Show the number of the weeks in the calendar views.
          '';
        };
        firstDayOfWeek = mkOption {
          default = null;
          type = types.nullOr (types.enum (range 0 6));
          description = ''
            Which day of the week (0=Sunday, 1=Monday etc.) should be the
            first day.
          '';
        };
      };

      entryPage = mkOption {
        # https://github.com/grocy/grocy/blob/v4.6.0/config-dist.php#L75-L78
        type = types.enum [
          "stock"
          "shoppinglist"
          "recipes"
          "chores"
          "tasks"
          "batteries"
          "equipment"
          "calendar"
          "mealplan"
        ];
        default = "stock";
        description = ''
          Specify an custom homepage if desired.
        '';
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        These lines go at the end of config.php verbatim.
      '';
      example = ''
        Setting('FEATURE_FLAG_RECIPES', false);
        Setting('FEATURE_FLAG_STOCK_PRODUCT_FREEZING', false);
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."grocy/config.php".text = ''
      <?php
      Setting('CULTURE', '${cfg.settings.culture}');
      Setting('CURRENCY', '${cfg.settings.currency}');
      Setting('CALENDAR_FIRST_DAY_OF_WEEK', '${toString cfg.settings.calendar.firstDayOfWeek}');
      Setting('CALENDAR_SHOW_WEEK_OF_YEAR', ${boolToString cfg.settings.calendar.showWeekNumber});
      Setting('ENTRY_PAGE', '${cfg.settings.entryPage}');
      ${cfg.extraConfig}
    '';

    users.users.grocy = {
      isSystemUser = true;
      createHome = true;
      home = cfg.dataDir;
      group = "nginx";
    };

    systemd.tmpfiles.rules = map (dirName: "d '${cfg.dataDir}/${dirName}' - grocy nginx - -") [
      "viewcache"
      "plugins"
      "settingoverrides"
      "storage"
    ];

    services.phpfpm.pools.grocy = {
      user = "grocy";
      group = "nginx";

      inherit (cfg.phpfpm) settings;
      inherit (cfg.package.passthru) phpPackage;

      phpEnv = {
        GROCY_CONFIG_FILE = "/etc/grocy/config.php";
        GROCY_DB_FILE = "${cfg.dataDir}/grocy.db";
        GROCY_STORAGE_DIR = "${cfg.dataDir}/storage";
        GROCY_PLUGIN_DIR = "${cfg.dataDir}/plugins";
        GROCY_CACHE_DIR = "${cfg.dataDir}/viewcache";
      };
    };

    # After an update of grocy, the viewcache needs to be deleted. Otherwise grocy will not work
    # https://github.com/grocy/grocy#how-to-update
    systemd.services.grocy-setup = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-grocy.service" ];
      unitConfig.RequiresMountsFor = [ cfg.dataDir ];
      script = ''
        rm -rf ${cfg.dataDir}/viewcache/*
      '';
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.hostName}" = mkMerge [
        {
          root = "${cfg.package}/public";
          locations."/".extraConfig = ''
            rewrite ^ /index.php;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.grocy.socket};
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            include ${config.services.nginx.package}/conf/fastcgi_params;
          '';
          locations."~ \\.(js|css|ttf|woff2?|png|jpe?g|svg)$".extraConfig = ''
            add_header Cache-Control "public, max-age=15778463";
            add_header X-Content-Type-Options nosniff;
            add_header X-Robots-Tag none;
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header Referrer-Policy no-referrer;
            access_log off;
          '';
          extraConfig = ''
            try_files $uri /index.php;
          '';
        }
        (mkIf cfg.nginx.enableSSL {
          enableACME = true;
          forceSSL = true;
        })
      ];
    };
  };

  meta = {
    maintainers = with maintainers; [ diogotcorreia ];
    doc = ./grocy.md;
  };
}
