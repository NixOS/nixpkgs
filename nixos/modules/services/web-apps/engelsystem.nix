{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    types
    ;

  cfg = config.services.engelsystem;
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "engelsystem" "config" ]
      [ "services" "engelsystem" "settings" ]
    )
  ];

  options.services.engelsystem = {
    enable = mkEnableOption "engelsystem, an online tool for coordinating volunteers and shifts on large events";

    package = mkPackageOption pkgs "engelsystem" { };

    domain = mkOption {
      type = types.str;
      example = "engelsystem.example.com";
      description = "Domain to serve on.";
    };

    createDatabase = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to create a local database automatically.
        This will override every database setting in {option}`services.engelsystem.settings`.
      '';
    };

    settings = mkOption {
      type = types.attrs;
      default = {
        database = {
          host = "localhost";
          database = "engelsystem";
          username = "engelsystem";
        };
      };
      example = {
        maintenance = false;
        database = {
          host = "database.example.com";
          database = "engelsystem";
          username = "engelsystem";
          password._secret = "/var/keys/engelsystem/database";
        };
        email = {
          driver = "smtp";
          host = "smtp.example.com";
          port = 587;
          from.address = "engelsystem@example.com";
          from.name = "example engelsystem";
          encryption = "tls";
          username = "engelsystem@example.com";
          password._secret = "/var/keys/engelsystem/mail";
        };
        autoarrive = true;
        min_password_length = 6;
        default_locale = "de_DE";
      };
      description = ''
        Options to be added to config.php, as a nix attribute set. Options containing secret data
        should be set to an attribute set containing the attribute _secret - a string pointing to a
        file containing the value the option should be set to. See the example to get a better
        picture of this: in the resulting config.php file, the email.password key will be set to
        the contents of the /var/keys/engelsystem/mail file.

        See <https://engelsystem.de/doc/admin/configuration/> for available options.

        Note that the admin user login credentials cannot be set here - they always default to
        admin:asdfasdf. Log in and change them immediately.
      '';
    };
  };

  config = mkIf cfg.enable {
    # create database
    services.mysql = mkIf cfg.createDatabase {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureUsers = [
        {
          name = "engelsystem";
          ensurePermissions = {
            "engelsystem.*" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [ "engelsystem" ];
    };

    environment.etc."engelsystem/config.php".source = pkgs.writeText "config.php" ''
      <?php
      return json_decode(file_get_contents("/var/lib/engelsystem/config.json"), true);
    '';

    services.phpfpm.pools.engelsystem = {
      user = "engelsystem";
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}".locations = {
        "/" = {
          root = "${cfg.package}/share/php/engelsystem/public";
          extraConfig = ''
            index index.php;
            try_files $uri $uri/ /index.php?$args;
            autoindex off;
          '';
        };
        "~ \\.php$" = {
          root = "${cfg.package}/share/php/engelsystem/public";
          extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.engelsystem.socket};
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include ${config.services.nginx.package}/conf/fastcgi_params;
            include ${config.services.nginx.package}/conf/fastcgi.conf;
          '';
        };
      };
    };

    systemd.services."engelsystem-init" = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script =
        let
          genConfigScript = pkgs.writeScript "engelsystem-gen-config.sh" (
            utils.genJqSecretsReplacementSnippet cfg.settings "config.json"
          );
        in
        ''
          umask 077
          mkdir -p /var/lib/engelsystem/storage/app
          mkdir -p /var/lib/engelsystem/storage/cache/views
          cd /var/lib/engelsystem
          ${genConfigScript}
          chmod 400 config.json
          chown -R engelsystem .
        '';
    };
    systemd.services."engelsystem-migrate" = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "engelsystem";
        Group = "engelsystem";
      };
      script = ''
        versionFile="/var/lib/engelsystem/.version"
        version=$(cat "$versionFile" 2>/dev/null || echo 0)

        if [[ $version != ${cfg.package.version} ]]; then
          # prune template cache between releases
          rm -rfv /var/lib/engelsystem/storage/cache/*

          ${cfg.package}/bin/migrate

          echo ${cfg.package.version} > "$versionFile"
        fi
      '';
      after = [
        "engelsystem-init.service"
        "mysql.service"
      ];
    };
    systemd.services."phpfpm-engelsystem".after = [ "engelsystem-migrate.service" ];

    users.users.engelsystem = {
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/engelsystem/storage";
      group = "engelsystem";
    };
    users.groups.engelsystem = { };
  };
}
