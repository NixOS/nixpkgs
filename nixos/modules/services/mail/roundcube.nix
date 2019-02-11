{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.roundcube;
in
{
  options.services.roundcube = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable roundcube.

        Also enables nginx virtual host management.
        Further nginx configuration can be done by adapting <literal>services.nginx.virtualHosts.&lt;name&gt;</literal>.
        See <xref linkend="opt-services.nginx.virtualHosts"/> for further information.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.roundcube;
      example = literalExample ''
        roundcube.withPlugins (plugins: [ plugins.persistent_login ])
      '';
      description = ''
        The package which contains roundcube's sources. Can be overriden to create
        an environment which contains roundcube and third-party plugins.
      '';
    };

    hostName = mkOption {
      type = types.str;
      example = "webmail.example.com";
      description = "Hostname to use for the nginx vhost";
    };

    productName = mkOption {
      type = types.str;
      default = "Roundcube Webmail";
      description = "Name your service. This is displayed on the login screen and in the window title";
    };

    imap = {
      server = mkOption {
        type = types.str;
        default = "tls://%n";
        description = ''
          The IMAP host chosen to perform the log-in.
          Leave blank to show a textbox at login, give a list of hosts to display a pulldown menu or set one host as string.
          To use SSL/TLS connection, enter hostname with prefix ssl:// or tls://
          Supported replacement variables:
            %n - hostname ($_SERVER['SERVER_NAME'])
            %t - hostname without the first part
            %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
            %s - domain name after the '@' from e-mail address provided at login screen
          For example %n = mail.domain.tld, %t = domain.tld
          WARNING: After hostname change update of mail_host column in users table is required to match old user data records with the new host.
        '';
      };
      port = mkOption {
        type = types.int;
        default = 143;
        description = "TCP port used for IMAP connections";
      };
      userDomain = mkOption {
        type = types.str;
        default = "%d";
        description = ''
          Automatically add this domain to user names for login
          Only for IMAP servers that require full e-mail addresses for login
          Specify an array with 'host' => 'domain' values to support multiple hosts
          Supported replacement variables:
            %h - user's IMAP hostname
            %n - hostname ($_SERVER['SERVER_NAME'])
            %t - hostname without the first part
            %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
            %z - IMAP domain (IMAP hostname without the first part)
          For example %n = mail.domain.tld, %t = domain.tld
        '';
      };
      authType = mkOption {
        type = types.enum [ "DIGEST-MD5" "CRAM-MD5" "LOGIN" "PLAIN" "IMAP" "null" ];
        default = "null";
        description = ''
          IMAP authentication method (DIGEST-MD5, CRAM-MD5, LOGIN, PLAIN or null).
          Use 'IMAP' to authenticate with IMAP LOGIN command.
          By default the most secure method (from supported) will be selected.
        '';
      };
    };

    smtp = {
      server = mkOption {
        type = types.str;
        default = "tls://%n";
        example = "localhost";
        description = ''
          SMTP server host (for sending mails).
          Enter hostname with prefix tls:// to use STARTTLS, or use prefix ssl:// to use the deprecated SSL over SMTP (aka SMTPS)
          Supported replacement variables:
            %h - user's IMAP hostname
            %n - hostname ($_SERVER['SERVER_NAME'])
            %t - hostname without the first part
            %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
            %z - IMAP domain (IMAP hostname without the first part)
          For example %n = mail.domain.tld, %t = domain.tld
        '';
      };
      port = mkOption {
        type = types.int;
        default = 587;
        description = "SMTP port (use 587 for STARTTLS or 465 for the deprecated SSL over SMTP (aka SMTPS))";
      };
      user = mkOption {
        type = types.str;
        default = "%u";
        description = "SMTP username (if required) if you use %u as the username Roundcube will use the current username for login";
      };
      password = mkOption {
        type = types.str;
        default = "%p";
        description = "SMTP password (if required) if you use %p as the password Roundcube will use the current user's password for login";
      };
      authType = mkOption {
        type = types.enum [ "DIGEST-MD5" "CRAM-MD5" "LOGIN" "PLAIN" "null" ];
        default = "null";
        description = "SMTP AUTH type (DIGEST-MD5, CRAM-MD5, LOGIN, PLAIN or empty to use best server supported one)";
      };
    };

    database = {
      username = mkOption {
        type = types.str;
        default = "roundcube";
        description = "Username for the postgresql connection";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Host of the postgresql server. If this is not set to
          <literal>localhost</literal>, you have to create the
          postgresql user and database yourself, with appropriate
          permissions.
        '';
      };
      password = mkOption {
        type = types.str;
        description = "Password for the postgresql connection";
      };
      dbname = mkOption {
        type = types.str;
        default = "roundcube";
        description = "Name of the postgresql database";
      };
      dbprefix = mkOption {
        type = types.str;
        default = "rc";
        description = "Name of the prefix for table";
      };
    };

    maxMessageSize = mkOption {
      type = types.str;
      default = "25M";
      description = ''
        Message size limit. Note that SMTP server(s) may use a different value. This limit is verified when user attaches files to a composed message.
        Size in bytes (possible unit suffix: K, M, G)
      '';
    };

    cipherMethod = mkOption {
      type = types.str;
      default = "AES-256-CBC";
      description = ''
        Encryption algorithm. You can use any method supported by openssl.
      '';
    };

    plugins = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of roundcube plugins to enable. Currently, only those directly shipped with Roundcube are supported.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration for Roundcube Webmail instance";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."roundcube/config.inc.php".text = ''
      <?php

      $config = array();
      // ----------------------------------
      // SQL DATABASE
      // ----------------------------------
      $config['db_prefix'] = '${cfg.database.dbprefix}';
      $config['db_dsnw'] = 'pgsql://${cfg.database.username}:${cfg.database.password}@${cfg.database.host}/${cfg.database.dbname}';

      // ----------------------------------
      // IMAP
      // ----------------------------------
      $config['default_host'] = '${cfg.imap.server}';
      $config['default_port'] = ${toString cfg.imap.port};
      $config['imap_auth_type'] = '${cfg.imap.authType}';
      $config['username_domain'] = '${cfg.imap.userDomain}';

      // ----------------------------------
      // SMTP
      // ----------------------------------
      $config['smtp_server'] = '${cfg.smtp.server}';
      $config['smtp_port'] = ${toString cfg.smtp.port};
      $config['smtp_user'] = '${cfg.smtp.user}';
      $config['smtp_pass'] = '${cfg.smtp.password}';
      $config['smtp_auth_type'] = '${cfg.smtp.authType}';

      // ----------------------------------
      // SYSTEM
      // ----------------------------------
      $config['enable_installer'] = false;
      $config['product_name'] = '${cfg.productName}';
      $config['cipher_method'] = '${cfg.cipherMethod}';
      $config['log_driver'] = 'syslog';
      $config['max_message_size'] = '${cfg.maxMessageSize}';
      $config['plugins'] = [${concatMapStringsSep "," (p: "'${p}'") cfg.plugins}];

      ${cfg.extraConfig}
    '';

    services.nginx = {
      enable = true;
      virtualHosts = {
        ${cfg.hostName} = {
          forceSSL = mkDefault true;
          enableACME = mkDefault true;
          locations."/" = {
            root = cfg.package;
            index = "index.php";
            extraConfig = ''
              location ~* \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/run/phpfpm/roundcube;
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
              }
            '';
          };
        };
      };
    };

    services.postgresql = mkIf (cfg.database.host == "localhost") {
      enable = true;
    };

    services.phpfpm.poolConfigs.roundcube = ''
      listen = /run/phpfpm/roundcube
      listen.owner = nginx
      listen.group = nginx
      listen.mode = 0660
      user = nginx
      pm = dynamic
      pm.max_children = 75
      pm.start_servers = 2
      pm.min_spare_servers = 1
      pm.max_spare_servers = 20
      pm.max_requests = 500
      php_admin_value[error_log] = 'stderr'
      php_admin_flag[log_errors] = on
      php_admin_value[post_max_size] = 25M
      php_admin_value[upload_max_filesize] = 25M
      catch_workers_output = yes
    '';
    systemd.services.phpfpm-roundcube.after = [ "roundcube-setup.service" ];

    systemd.services.roundcube-setup = let
      pgSuperUser = config.services.postgresql.superUser;
    in {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ config.services.postgresql.package ];
      script = ''
        mkdir -p /var/lib/roundcube
        if [ ! -f /var/lib/roundcube/db-created ]; then
          if [ "${cfg.database.host}" = "localhost" ]; then
            ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create role ${cfg.database.username} with login password '${cfg.database.password}'";
            ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} psql postgres -c "create database ${cfg.database.dbname} with owner ${cfg.database.username}";
          fi
          PGPASSWORD=${cfg.database.password} ${pkgs.postgresql}/bin/psql -U ${cfg.database.username} \
            -f ${cfg.package}/SQL/postgres.initial.sql \
            -h ${cfg.database.host} ${cfg.database.dbname}
          touch /var/lib/roundcube/db-created
        fi

        ${pkgs.php}/bin/php ${cfg.package}/bin/update.sh
      '';
      serviceConfig.Type = "oneshot";
    };
  };
}
