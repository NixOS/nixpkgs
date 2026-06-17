{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkForce
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.strichliste;

  format = pkgs.formats.yaml { };
  settingsFile = format.generate "strichliste.yaml" {
    parameters.strichliste = cfg.settings;
  };

  unitDependencies =
    lib.optionals (
      lib.hasInfix "pgpsql" cfg.environment.DATABASE_URL
      || lib.hasInfix "postgres" cfg.environment.DATABASE_URL
    ) [ "postgresql.service" ]
    ++ lib.optionals (lib.hasInfix "mysql" cfg.environment.DATABASE_URL) [ "mysql.service" ];
in
{
  meta.buildDocsInSandbox = false;

  options.services.strichliste = {
    enable = mkEnableOption "strichliste, a web based tally sheet.";

    packages = {
      backend = mkPackageOption pkgs "strichliste" { };
      frontend = mkOption {
        type = types.package;
        default = pkgs.strichliste.frontend;
        description = ''
          The strichliste-frontend package to use.
        '';
      };
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          common = {
            idleTimeout = mkOption {
              type = types.int;
              default = 30000;
              description = ''
                Time until the app returns to the start page.
              '';
            };
          };

          user = {
            stalePeriod = mkOption {
              type = types.str;
              default = "10 day";
              example = "1 week";
              description = ''
                Duration after which users are listed as inactive.

                The format used is documented in <https://www.php.net/manual/en/dateinterval.createfromdatestring.php>.

                ::: {.tip}
                This helps unclutter the user listing by prioritizing active users.
                :::
              '';
            };
          };

          i18n = {
            timezone = mkOption {
              type = types.str;
              default = config.time.timeZone;
              defaultText = lib.literalExpression "config.time.timeZone";
              example = "Europe/Berlin";
              description = ''
                Timezone used throughout the app, e.g. in the transaction log.
              '';
            };

            language = mkOption {
              type = types.str;
              default = "en";
              example = "de";
              description = ''
                Language used throughout the app.
              '';
            };

            currency = {
              name = mkOption {
                type = types.str;
                example = "Euro";
                description = ''
                  Name of the currency.
                '';
              };

              symbol = mkOption {
                type = types.str;
                example = "€";
                description = ''
                  Symbol for the currency.
                '';
              };

              alpha3 = mkOption {
                type = types.str;
                example = "EUR";
                description = ''
                  [ISO 4217] alpha code representing the currency.

                  [ISO 4217]: https://en.wikipedia.org/wiki/ISO_4217#List_of_ISO_4217_currency_codes
                '';
              };
            };
          };

          account = {
            lower = mkOption {
              type = types.int;
              default = -200000;
              example = 0;
              description = ''
                The credit limit for user accounts.
              '';
            };

            upper = mkOption {
              type = types.ints.positive;
              default = 200000;
              description = ''
                The maximum balance on a user account.
              '';
            };
          };

          payment = {
            boundary = {
              lower = mkOption {
                type = types.int;
                default = -2000;
                example = 0;
                description = ''
                  The lowest amount that can be used for payments.
                '';
              };

              upper = mkOption {
                type = types.ints.positive;
                default = 15000;
                description = ''
                  The highest amount that can be used for payment.
                '';
              };
            };

            deposit = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow money deposits.
                '';
              };

              custom = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow custom amounts for deposits.
                '';
              };

              steps = mkOption {
                type = types.listOf (
                  types.oneOf [
                    types.int
                    types.float
                  ]
                );
                example = [
                  0.5
                  1
                  2
                  5
                  10
                  20
                ];
                description = ''
                  List of selectable deposit amounts.

                  This should match your most common coins and banknotes.
                '';
              };
            };

            dispense = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow spending money.
                '';
              };

              custom = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow custom spending amounts.
                '';
              };

              steps = mkOption {
                type = types.listOf (
                  types.oneOf [
                    types.int
                    types.float
                  ]
                );
                example = [
                  0.5
                  1
                  2
                  5
                  10
                  20
                ];
                description = ''
                  List of selectable spending amounts.

                  This should match your most common products.
                '';
              };
            };

            transaction = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow transactions between user accounts.
                '';
              };
            };

            undo = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow undoing transactions withing the {option}`services.strichliste.settings.payment.undo.timeout` period.
                '';
              };

              delete = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether to allow deleting within the {option}`services.strichliste.settings.payment.undo.timeout` period.
                '';
              };

              timeout = mkOption {
                type = types.str;
                default = "5 minute";
                description = ''
                  The time period after creating a transaction in which undoing/deleting remains possible.

                  The format used is documented in <https://www.php.net/manual/en/dateinterval.createfromdatestring.php>.
                '';
              };
            };
          };
        };
      };
      description = ''
        The {file}`strichliste.yaml` configuration as a Nix attribute set.

        See the [configuration reference](https://github.com/strichliste/strichliste-backend/blob/v${cfg.packages.backend.version}/docs/Config.md)
        for possible options.
      '';
    };

    domain = mkOption {
      type = types.str;
      example = "strichliste.example.com";
      description = ''
        Domain name used to configure the webserver virtual host.
      '';
    };

    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrs;
        options = {
          APP_ENV = mkOption {
            type = types.str;
            default = "prod";
            description = ''
              The active environment.
            '';
          };
          APP_LOG_DIR = mkOption {
            type = types.path;
            default = "/var/log/strichliste";
            description = ''
              Directory to write logs.
            '';
          };
          APP_CACHE_DIR = mkOption {
            type = types.path;
            default = "/var/cache/strichliste";
            description = ''
              Directory used for caching.
            '';
          };
          CORS_ALLOW_ORIGIN = mkOption {
            type = types.str;
            default = "^https?://${config.services.strichliste.domain}(:[0-9]+)?$";
            defaultText = lib.literalExpression "^https?://$${config.services.strichliste.domain}(:[0-9]+)?$";
            description = ''
              Regular expression defining the allowed CORS origins.
            '';
          };
          DATABASE_URL = mkOption {
            type = types.str;
            default = "sqlite:////var/lib/strichliste/db.sqlite";
            example = "postgresql://strichliste@localhost/strichliste?host=/run/postgresql";
            description = ''
              See <https://www.doctrine-project.org/projects/doctrine-dbal/en/3.9/reference/configuration.html#connecting-using-a-url>
              for more URL examples.
            '';
          };
        };
      };
      default = { };
      description = ''
        Environment variables consumed by Symfony.

        See <https://github.com/strichliste/strichliste-backend/blob/v${cfg.packages.backend.version}/.env.dist> for possible options.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = lib.literalExpression ''
        [
          "/run/keys/strichliste.env"
        ]
      '';
      description = ''
        Environment files to configure Symfony.

        See <https://github.com/strichliste/strichliste-backend/blob/v${cfg.packages.backend.version}/.env.dist> for possible options.

        ::: {.important}
        You should configure `APP_SECRET` here.
        :::
      '';
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable and configure an nginx vhost to serve strichliste.
        '';
      };

      virtualHost = mkOption {
        type = types.submodule (
          import ../web-servers/nginx/vhost-options.nix {
            inherit config lib;
          }
        );
        example = lib.literalExpression ''
          {
            enableACME = true;
            forceSSL = true;
          }
        '';
        description = ''
          Nginx virtual settings to allow direct customization of its settings.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.nginx.enable) {
      services.phpfpm.pools.strichliste.settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
      };

      services.nginx.enable = true;
      services.nginx.virtualHosts.${cfg.domain} = mkMerge [
        cfg.nginx.virtualHost
        {
          root = mkForce "${cfg.packages.frontend}";
          locations = {
            "/" = {
              tryFiles = toString [
                "$uri"
                "$uri/"
                "index.html"
              ];
            };

            "/api/" = {
              fastcgiParams = {
                SCRIPT_FILENAME = "${cfg.packages.backend}/share/php/strichliste-backend/public/index.php";
                SCRIPT_NAME = "/index.php";
                REQUEST_URI = "$request_uri";

                modHeadersAvailable = "true";
                front_controller_active = "true";
              };
              extraConfig = ''
                fastcgi_intercept_errors on;
                fastcgi_pass unix:${config.services.phpfpm.pools.strichliste.socket};
                fastcgi_request_buffering off;
              '';
            };
          };
        }
      ];
    })

    (mkIf cfg.enable {
      environment.etc."strichliste.yaml".source = settingsFile;

      systemd.tmpfiles.settings."strichliste" = {
        ${cfg.environment.APP_CACHE_DIR}.d = {
          user = "strichliste";
          group = "strichliste";
          mode = "0700";
        };
        ${cfg.environment.APP_LOG_DIR}.d = {
          user = "strichliste";
          group = "strichliste";
          mode = "0700";
        };
      };

      systemd.services.strichliste-migrate = {
        wantedBy = [ "phpfpm-strichliste.service" ];
        before = [ "phpfpm-strichliste.service" ];
        wants = unitDependencies;
        after = unitDependencies;
        inherit (cfg) environment;
        preStart = ''
          set -ex
          if [ ! -e "/var/lib/strichliste/.db-init" ]; then
            ${lib.optionalString (lib.hasInfix "sqlite" cfg.environment.DATABASE_URL) ''
              ${lib.getExe cfg.packages.backend} doctrine:database:create
            ''}
            ${lib.getExe cfg.packages.backend} doctrine:schema:create
            touch "/var/lib/strichliste/.db-init"
          fi
        '';
        serviceConfig = {
          Type = "exec";
          User = "strichliste";
          Group = "strichliste";
          EnvironmentFile = cfg.environmentFiles;
          ExecStart = toString [
            (lib.getExe cfg.packages.backend)
            "doctrine:migrations:migrate"
            "--allow-no-migration"
            "--no-interaction"
          ];
        };
      };

      systemd.services.phpfpm-strichliste = {
        inherit (cfg) environment;
        serviceConfig.EnvironmentFile = cfg.environmentFiles;
      };

      services.phpfpm.pools.strichliste = {
        user = "strichliste";
        group = "strichliste";
        settings = {
          # support environment variables
          "clear_env" = false;
          "pm" = "dynamic";
          "pm.max_children" = 8;
          "pm.start_servers" = 1;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 256;
        };
        inherit (cfg.packages.backend) phpPackage;
      };

      users.groups.strichliste = { };
      users.users.strichliste = {
        group = "strichliste";
        home = "/var/lib/strichliste";
        createHome = true;
        isSystemUser = true;
      };
    })
  ];
}
