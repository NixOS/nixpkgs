{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.invoiceplane;
  eachSite = cfg.sites;
  user = "invoiceplane";
  webserver = config.services.${cfg.webserver};

  invoiceplane-config =
    hostName: cfg:
    pkgs.writeText "ipconfig.php" ''
      IP_URL=http://${hostName}
      ENABLE_DEBUG=false
      DISABLE_SETUP=false
      REMOVE_INDEXPHP=false
      DB_HOSTNAME=${cfg.database.host}
      DB_USERNAME=${cfg.database.user}
      # NOTE: file_get_contents adds newline at the end of returned string
      DB_PASSWORD=${
        lib.optionalString (
          cfg.database.passwordFile != null
        ) "trim(file_get_contents('${cfg.database.passwordFile}'), \"\\r\\n\")"
      }
      DB_DATABASE=${cfg.database.name}
      DB_PORT=${toString cfg.database.port}
      SESS_EXPIRATION=864000
      ENABLE_INVOICE_DELETION=false
      DISABLE_READ_ONLY=false
      ENCRYPTION_KEY=
      ENCRYPTION_CIPHER=AES-256
      SETUP_COMPLETED=false
      REMOVE_INDEXPHP=true
    '';

  mkPhpValue =
    v:
    if lib.isString v then
      lib.escapeShellArg v
    # NOTE: If any value contains a , (comma) this will not get escaped
    else if lib.isList v && lib.strings.isConvertibleWithToString v then
      lib.escapeShellArg (lib.concatMapStringsSep "," toString v)
    else if lib.isInt v then
      toString v
    else if lib.isBool v then
      lib.boolToString v
    else
      abort "The Invoiceplane config value ${lib.generators.toPretty { } v} can not be encoded.";

  extraConfig =
    hostName: cfg:
    let
      settings = lib.mapAttrsToList (k: v: "${k}=${mkPhpValue v}") cfg.settings;
    in
    pkgs.writeText "extraConfig.php" (lib.concatStringsSep "\n" settings);

  pkg =
    hostName: cfg:
    pkgs.stdenv.mkDerivation rec {
      pname = "invoiceplane-${hostName}";
      version = src.version;
      src = pkgs.invoiceplane;

      postPatch = ''
        # Patch index.php file to load additional config file
        substituteInPlace index.php \
          --replace-fail "require('vendor/autoload.php');" "require('vendor/autoload.php'); \$dotenv = Dotenv\Dotenv::createImmutable(__DIR__, 'extraConfig.php'); \$dotenv->load();";
      '';

      installPhase = ''
        mkdir -p $out
        cp -r * $out/

        # symlink uploads and log directories
        rm -r $out/uploads $out/application/logs $out/vendor/mpdf/mpdf/tmp
        ln -sf ${cfg.stateDir}/uploads $out/
        ln -sf ${cfg.stateDir}/logs $out/application/
        ln -sf ${cfg.stateDir}/tmp $out/vendor/mpdf/mpdf/

        # symlink the InvoicePlane config
        ln -s ${cfg.stateDir}/ipconfig.php $out/ipconfig.php

        # symlink the extraConfig file
        ln -s ${extraConfig hostName cfg} $out/extraConfig.php

        # symlink additional templates
        ${lib.concatMapStringsSep "\n" (
          template: "cp -r ${template}/. $out/application/views/invoice_templates/pdf/"
        ) cfg.invoiceTemplates}
      '';
    };

  siteOpts =
    { lib, name, ... }:
    {
      options = {

        enable = lib.mkEnableOption "InvoicePlane web application";

        stateDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/invoiceplane/${name}";
          description = ''
            This directory is used for uploads of attachments and cache.
            The directory passed here is automatically created and permissions
            adjusted as required.
          '';
        };

        database = {
          host = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Database host address.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 3306;
            description = "Database host port.";
          };

          name = lib.mkOption {
            type = lib.types.str;
            default = "invoiceplane";
            description = "Database name.";
          };

          user = lib.mkOption {
            type = lib.types.str;
            default = "invoiceplane";
            description = "Database user.";
          };

          passwordFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/run/keys/invoiceplane-dbpassword";
            description = ''
              A file containing the password corresponding to
              {option}`database.user`.
            '';
          };

          createLocally = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Create the database and database user locally.";
          };
        };

        invoiceTemplates = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          description = ''
            List of path(s) to respective template(s) which are copied from the 'invoice_templates/pdf' directory.

            ::: {.note}
            These templates need to be packaged before use, see example.
            :::
          '';
          example = lib.literalExpression ''
            let
              # Let's package an example template
              template-vtdirektmarketing = pkgs.stdenv.mkDerivation {
                name = "vtdirektmarketing";
                # Download the template from a public repository
                src = pkgs.fetchgit {
                  url = "https://git.project-insanity.org/onny/invoiceplane-vtdirektmarketing.git";
                  sha256 = "1hh0q7wzsh8v8x03i82p6qrgbxr4v5fb05xylyrpp975l8axyg2z";
                };
                sourceRoot = ".";
                # Installing simply means copying template php file to the output directory
                installPhase = ""
                  mkdir -p $out
                  cp invoiceplane-vtdirektmarketing/vtdirektmarketing.php $out/
                "";
              };
            # And then pass this package to the template list like this:
            in [ template-vtdirektmarketing ]
          '';
        };

        poolConfig = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              str
              int
              bool
            ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 4;
            "pm.max_requests" = 500;
          };
          description = ''
            Options for the InvoicePlane PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };

        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = ''
            Structural InvoicePlane configuration. Refer to
            <https://github.com/InvoicePlane/InvoicePlane/blob/master/ipconfig.php.example>
            for details and supported values.
          '';
          example = lib.literalExpression ''
            {
              SETUP_COMPLETED = true;
              DISABLE_SETUP = true;
              IP_URL = "https://invoice.example.com";
            }
          '';
        };

        cron = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Enable cron service which periodically runs Invoiceplane tasks.
              Requires key taken from the administration page. Refer to
              <https://wiki.invoiceplane.com/en/1.0/modules/recurring-invoices>
              on how to configure it.
            '';
          };
          key = lib.mkOption {
            type = lib.types.str;
            description = "Cron key taken from the administration page.";
          };
        };

      };

    };
in
{
  # interface
  options = {
    services.invoiceplane = lib.mkOption {
      type = lib.types.submodule {

        options.sites = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule siteOpts);
          default = { };
          description = "Specification of one or more InvoicePlane sites to serve";
        };

        options.webserver = lib.mkOption {
          type = lib.types.enum [
            "caddy"
            "nginx"
          ];
          default = "caddy";
          example = "nginx";
          description = ''
            Which webserver to use for virtual host management.
          '';
        };
      };
      default = { };
      description = "InvoicePlane configuration.";
    };

  };

  # implementation
  config = lib.mkIf (eachSite != { }) (lib.mkMerge [
    {

      assertions = lib.flatten (
        lib.mapAttrsToList (hostName: cfg: [
          {
            assertion = cfg.database.createLocally -> cfg.database.user == user;
            message = ''services.invoiceplane.sites."${hostName}".database.user must be ${user} if the database is to be automatically provisioned'';
          }
          {
            assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
            message = ''services.invoiceplane.sites."${hostName}".database.passwordFile cannot be specified if services.invoiceplane.sites."${hostName}".database.createLocally is set to true.'';
          }
          {
            assertion = cfg.cron.enable -> cfg.cron.key != null;
            message = ''services.invoiceplane.sites."${hostName}".cron.key must be set in order to use cron service.'';
          }
        ]) eachSite
      );

      services.mysql = lib.mkIf (lib.any (v: v.database.createLocally) (lib.attrValues eachSite)) {
        enable = true;
        package = lib.mkDefault pkgs.mariadb;
        ensureDatabases = lib.mapAttrsToList (hostName: cfg: cfg.database.name) eachSite;
        ensureUsers = lib.mapAttrsToList (hostName: cfg: {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }) eachSite;
      };

      services.phpfpm = {
        phpPackage = pkgs.php81;
        pools = lib.mapAttrs' (
          hostName: cfg:
          (lib.nameValuePair "invoiceplane-${hostName}" {
            inherit user;
            group = webserver.group;
            settings = {
              "listen.owner" = webserver.user;
              "listen.group" = webserver.group;
            } // cfg.poolConfig;
          })
        ) eachSite;
      };

    }

    {

      systemd.tmpfiles.rules = lib.flatten (
        lib.mapAttrsToList (hostName: cfg: [
          "d ${cfg.stateDir} 0750 ${user} ${webserver.group} - -"
          "f ${cfg.stateDir}/ipconfig.php 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/logs 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/uploads 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/uploads/archive 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/uploads/customer_files 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/uploads/temp 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/uploads/temp/mpdf 0750 ${user} ${webserver.group} - -"
          "d ${cfg.stateDir}/tmp 0750 ${user} ${webserver.group} - -"
        ]) eachSite
      );

      systemd.services.invoiceplane-config = {
        serviceConfig.Type = "oneshot";
        script = lib.concatStrings (
          lib.mapAttrsToList (hostName: cfg: ''
            mkdir -p ${cfg.stateDir}/logs \
                     ${cfg.stateDir}/uploads
            if ! grep -q IP_URL "${cfg.stateDir}/ipconfig.php"; then
              cp "${invoiceplane-config hostName cfg}" "${cfg.stateDir}/ipconfig.php"
            fi
          '') eachSite
        );
        wantedBy = [ "multi-user.target" ];
      };

      users.users.${user} = {
        group = webserver.group;
        isSystemUser = true;
      };

    }
    {

      # Cron service implementation

      systemd.timers = lib.mapAttrs' (
        hostName: cfg:
        (lib.nameValuePair "invoiceplane-cron-${hostName}" (
          lib.mkIf cfg.cron.enable {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnBootSec = "5m";
              OnUnitActiveSec = "5m";
              Unit = "invoiceplane-cron-${hostName}.service";
            };
          }
        ))
      ) eachSite;

      systemd.services = lib.mapAttrs' (
        hostName: cfg:
        (lib.nameValuePair "invoiceplane-cron-${hostName}" (
          lib.mkIf cfg.cron.enable {
            serviceConfig = {
              Type = "oneshot";
              User = user;
              ExecStart = "${pkgs.curl}/bin/curl --header 'Host: ${hostName}' http://localhost/invoices/cron/recur/${cfg.cron.key}";
            };
          }
        ))
      ) eachSite;

    }

    (lib.mkIf (cfg.webserver == "caddy") {
      services.caddy = {
        enable = true;
        virtualHosts = lib.mapAttrs' (
          hostName: cfg:
          (lib.nameValuePair "http://${hostName}" {
            extraConfig = ''
              root * ${pkg hostName cfg}
              file_server
              php_fastcgi unix/${config.services.phpfpm.pools."invoiceplane-${hostName}".socket}
            '';
          })
        ) eachSite;
      };
    })

    (lib.mkIf (cfg.webserver == "nginx") {
      services.nginx = {
        enable = true;
        virtualHosts = lib.mapAttrs' (
          hostName: cfg:
          (lib.nameValuePair hostName {
            root = pkg hostName cfg;
            extraConfig = ''
              index index.php index.html index.htm;

              if (!-e $request_filename){
                rewrite ^(.*)$ /index.php break;
              }
            '';

            locations = {
              "/setup".extraConfig = ''
                rewrite ^(.*)$ http://${hostName}/ redirect;
              '';

              "~ .php$" = {
                extraConfig = ''
                  fastcgi_split_path_info ^(.+\.php)(/.+)$;
                  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                  fastcgi_pass unix:${config.services.phpfpm.pools."invoiceplane-${hostName}".socket};
                  include ${config.services.nginx.package}/conf/fastcgi_params;
                  include ${config.services.nginx.package}/conf/fastcgi.conf;
                '';
              };
            };
          })
        ) eachSite;
      };
    })

  ]);
}
