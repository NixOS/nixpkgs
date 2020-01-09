{ config, pkgs, lib, ... }:

let

  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption;
  inherit (lib) literalExample optional optionalString types;

  cfg = config.services.fresh-rss;
  fpm = config.services.phpfpm.pools.fresh-rss;

  user = "freshrss";
  group = config.services.httpd.group;
  stateDir = "/var/lib/fresh-rss";

in
{
  # interface
  options = {
    services.fresh-rss = {

      enable = mkEnableOption "FreshRSS";

      package = mkOption {
        type = types.package;
        default = pkgs.fresh-rss;
        description = "Which FreshRSS package to use.";
      };

      initialPassword = mkOption {
        type = types.str;
        example = "correcthorsebatterystaple";
        description = ''
          Specifies the initial password for the admin, i.e. the password assigned if the user does not already exist.
          The password specified here is world-readable in the Nix store, so it should be changed promptly.
        '';
      };

      database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.port;
          default = 3306;
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "freshrss";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "freshrss";
          description = "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/freshrss-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Create the database and database user locally.
            This currently only applies if database type "mysql" is selected.
          '';
        };
      };

      virtualHost = mkOption {
        type = types.submodule (import ../web-servers/apache-httpd/per-server-options.nix);
        example = literalExample ''
          {
            hostName = "fresh-rss.example.org";
            adminAddr = "webmaster@example.org";
            forceSSL = true;
            enableACME = true;
          }
        '';
        description = ''
          Apache configuration can be done by adapting <option>services.httpd.virtualHosts</option>.
          See <xref linkend="opt-services.httpd.virtualHosts"/> for further information.
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
        description = ''
          Options for the FreshRSS PHP pool. See the documentation on <literal>php-fpm.conf</literal>
          for details on configuration directives.
        '';
      };

    };
  };

  # implementation
  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.fresh-rss.database.user must be set to ${user} if services.fresh-rss.database.createLocally is set true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.fresh-rss.database.createLocally is set to true";
      }
    ];

    services.mysql = mkIf cfg.database.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.phpfpm.pools.fresh-rss = {
      inherit user group;
      settings = {
        "listen.owner" = config.services.httpd.user;
        "listen.group" = config.services.httpd.group;
      } // cfg.poolConfig;
    };

    services.httpd = {
      enable = true;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.${cfg.virtualHost.hostName} = mkMerge [ cfg.virtualHost {
        documentRoot = mkForce "${cfg.package}/share/fresh-rss/p";
        extraConfig = ''
          <Directory "${cfg.package}/share/fresh-rss/p">
            <FilesMatch "\.php$">
              <If "-f %{REQUEST_FILENAME}">
                SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
              </If>
            </FilesMatch>

            AllowOverride AuthConfig FileInfo Indexes Limit
            Require all granted
          </Directory>

          <IfModule mod_http2.c>
            Protocols h2 http/1.1
          </IfModule>

          # for the API
          AllowEncodedSlashes On
        '';
      } ];
    };

    systemd.services.fresh-rss-init = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-fresh-rss.service" ];
      after = optional cfg.database.createLocally "mysql.service";
      script = ''
        cp -r ${cfg.package}/share/fresh-rss/data/. ${stateDir}
        chmod -R u+w ${stateDir}/

        if [ ! -f "${stateDir}/config.php" ]; then
          ${pkgs.php}/bin/php ${cfg.package}/share/fresh-rss/cli/do-install.php \
            --default_user admin \
            --db-type mysql \
            --db-host ${cfg.database.host}:${toString cfg.database.port} \
            --db-user ${cfg.database.user} \
            --db-base ${cfg.database.name} \
            ${optionalString (cfg.database.passwordFile != null) "--db-password `cat ${cfg.database.passwordFile}`"} \
            --disable_update

          ${pkgs.php}/bin/php ${cfg.package}/share/fresh-rss/cli/create-user.php \
            --user admin \
            --password '${cfg.initialPassword}'
        fi

        rm -f ${stateDir}/do-install.txt
      '';

      serviceConfig = {
        Type = "oneshot";
        User = user;
        Group = group;
        StateDirectory = "fresh-rss";
        StateDirectoryMode = "0750";
        PrivateTmp = true;
      };
    };

    systemd.services.httpd.after = optional cfg.database.createLocally "mysql.service";

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };
  };
}
