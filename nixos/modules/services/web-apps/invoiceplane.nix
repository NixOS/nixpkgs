{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.invoiceplane;
  eachSite = cfg.sites;
  user = "invoiceplane";
  webserver = config.services.${cfg.webserver};

  invoiceplane-config = hostName: cfg: pkgs.writeText "ipconfig.php" ''
    IP_URL=http://${hostName}
    ENABLE_DEBUG=false
    DISABLE_SETUP=false
    REMOVE_INDEXPHP=false
    DB_HOSTNAME=${cfg.database.host}
    DB_USERNAME=${cfg.database.user}
    # NOTE: file_get_contents adds newline at the end of returned string
    DB_PASSWORD=${if cfg.database.passwordFile == null then "" else "trim(file_get_contents('${cfg.database.passwordFile}'), \"\\r\\n\")"}
    DB_DATABASE=${cfg.database.name}
    DB_PORT=${toString cfg.database.port}
    SESS_EXPIRATION=864000
    ENABLE_INVOICE_DELETION=false
    DISABLE_READ_ONLY=false
    ENCRYPTION_KEY=
    ENCRYPTION_CIPHER=AES-256
    SETUP_COMPLETED=false
  '';

  extraConfig = hostName: cfg: pkgs.writeText "extraConfig.php" ''
    ${toString cfg.extraConfig}
  '';

  pkg = hostName: cfg: pkgs.stdenv.mkDerivation rec {
    pname = "invoiceplane-${hostName}";
    version = src.version;
    src = pkgs.invoiceplane;

    postPhase = ''
      # Patch index.php file to load additional config file
      substituteInPlace index.php \
        --replace "require('vendor/autoload.php');" "require('vendor/autoload.php'); \$dotenv = Dotenv\Dotenv::createImmutable(__DIR__, 'extraConfig.php'); \$dotenv->load();";
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
      ${concatMapStringsSep "\n" (template: "cp -r ${template}/. $out/application/views/invoice_templates/pdf/") cfg.invoiceTemplates}
    '';
  };

  siteOpts = { lib, name, ... }:
    {
      options = {

        enable = mkEnableOption (lib.mdDoc "InvoicePlane web application");

        stateDir = mkOption {
          type = types.path;
          default = "/var/lib/invoiceplane/${name}";
          description = lib.mdDoc ''
            This directory is used for uploads of attachements and cache.
            The directory passed here is automatically created and permissions
            adjusted as required.
          '';
        };

        database = {
          host = mkOption {
            type = types.str;
            default = "localhost";
            description = lib.mdDoc "Database host address.";
          };

          port = mkOption {
            type = types.port;
            default = 3306;
            description = lib.mdDoc "Database host port.";
          };

          name = mkOption {
            type = types.str;
            default = "invoiceplane";
            description = lib.mdDoc "Database name.";
          };

          user = mkOption {
            type = types.str;
            default = "invoiceplane";
            description = lib.mdDoc "Database user.";
          };

          passwordFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/keys/invoiceplane-dbpassword";
            description = lib.mdDoc ''
              A file containing the password corresponding to
              {option}`database.user`.
            '';
          };

          createLocally = mkOption {
            type = types.bool;
            default = true;
            description = lib.mdDoc "Create the database and database user locally.";
          };
        };

        invoiceTemplates = mkOption {
          type = types.listOf types.path;
          default = [];
          description = lib.mdDoc ''
            List of path(s) to respective template(s) which are copied from the 'invoice_templates/pdf' directory.

            ::: {.note}
            These templates need to be packaged before use, see example.
            :::
          '';
          example = literalExpression ''
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

        poolConfig = mkOption {
          type = with types; attrsOf (oneOf [ str int bool ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 4;
            "pm.max_requests" = 500;
          };
          description = lib.mdDoc ''
            Options for the InvoicePlane PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };

        extraConfig = mkOption {
          type = types.nullOr types.lines;
          default = null;
          example = ''
            SETUP_COMPLETED=true
            DISABLE_SETUP=true
            IP_URL=https://invoice.example.com
          '';
          description = lib.mdDoc ''
            InvoicePlane configuration. Refer to
            <https://github.com/InvoicePlane/InvoicePlane/blob/master/ipconfig.php.example>
            for details on supported values.
          '';
        };

      };

    };
in
{
  # interface
  options = {
    services.invoiceplane = mkOption {
      type = types.submodule {

        options.sites = mkOption {
          type = types.attrsOf (types.submodule siteOpts);
          default = {};
          description = lib.mdDoc "Specification of one or more WordPress sites to serve";
        };

        options.webserver = mkOption {
          type = types.enum [ "caddy" ];
          default = "caddy";
          description = lib.mdDoc ''
            Which webserver to use for virtual host management. Currently only
            caddy is supported.
          '';
        };
      };
      default = {};
      description = lib.mdDoc "InvoicePlane configuration.";
    };

  };

  # implementation
  config = mkIf (eachSite != {}) (mkMerge [{

    assertions = flatten (mapAttrsToList (hostName: cfg:
      [{ assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = ''services.invoiceplane.sites."${hostName}".database.user must be ${user} if the database is to be automatically provisioned'';
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = ''services.invoiceplane.sites."${hostName}".database.passwordFile cannot be specified if services.invoiceplane.sites."${hostName}".database.createLocally is set to true.'';
      }]
    ) eachSite);

    services.mysql = mkIf (any (v: v.database.createLocally) (attrValues eachSite)) {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = mapAttrsToList (hostName: cfg: cfg.database.name) eachSite;
      ensureUsers = mapAttrsToList (hostName: cfg:
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ) eachSite;
    };

    services.phpfpm = {
      phpPackage = pkgs.php81;
      pools = mapAttrs' (hostName: cfg: (
        nameValuePair "invoiceplane-${hostName}" {
          inherit user;
          group = webserver.group;
          settings = {
            "listen.owner" = webserver.user;
            "listen.group" = webserver.group;
          } // cfg.poolConfig;
        }
      )) eachSite;
    };

  }

  {
    systemd.tmpfiles.rules = flatten (mapAttrsToList (hostName: cfg: [
      "d ${cfg.stateDir} 0750 ${user} ${webserver.group} - -"
      "f ${cfg.stateDir}/ipconfig.php 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/logs 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/uploads 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/uploads/archive 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/uploads/customer_files 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/uploads/temp 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/uploads/temp/mpdf 0750 ${user} ${webserver.group} - -"
      "d ${cfg.stateDir}/tmp 0750 ${user} ${webserver.group} - -"
    ]) eachSite);

    systemd.services.invoiceplane-config = {
      serviceConfig.Type = "oneshot";
      script = concatStrings (mapAttrsToList (hostName: cfg:
        ''
          mkdir -p ${cfg.stateDir}/logs \
                   ${cfg.stateDir}/uploads
          if ! grep -q IP_URL "${cfg.stateDir}/ipconfig.php"; then
            cp "${invoiceplane-config hostName cfg}" "${cfg.stateDir}/ipconfig.php"
          fi
        '') eachSite);
      wantedBy = [ "multi-user.target" ];
    };

    users.users.${user} = {
      group = webserver.group;
      isSystemUser = true;
    };
  }

  (mkIf (cfg.webserver == "caddy") {
    services.caddy = {
      enable = true;
      virtualHosts = mapAttrs' (hostName: cfg: (
        nameValuePair "http://${hostName}" {
          extraConfig = ''
            root    * ${pkg hostName cfg}
            file_server

            php_fastcgi unix/${config.services.phpfpm.pools."invoiceplane-${hostName}".socket}
          '';
        }
      )) eachSite;
    };
  })


  ]);
}
