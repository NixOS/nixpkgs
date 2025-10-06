{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    any
    boolToString
    concatStringsSep
    isBool
    isString
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionalAttrs
    types
    mkPackageOption
    ;

  package = cfg.package.override { inherit (cfg) stateDir; };

  cfg = config.services.dolibarr;
  vhostCfg = lib.optionalAttrs (cfg.nginx != null) config.services.nginx.virtualHosts."${cfg.domain}";

  mkConfigFile =
    filename: settings:
    let
      # hack in special logic for secrets so we read them from a separate file avoiding the Nix store
      secretKeys = [
        "force_install_databasepass"
        "dolibarr_main_db_pass"
        "dolibarr_main_instance_unique_id"
      ];

      toStr =
        k: v:
        if (any (str: k == str) secretKeys) then
          v
        else if isString v then
          "'${v}'"
        else if isBool v then
          boolToString v
        else if v == null then
          "null"
        else
          toString v;
    in
    pkgs.writeText filename ''
      <?php
      ${concatStringsSep "\n" (mapAttrsToList (k: v: "\$${k} = ${toStr k v};") settings)}
    '';

  dbUnit =
    {
      "mysql" = "mysql.service";
      "postgresql" = "postgresql.target";
    }
    .${cfg.database.type};

  dbPort =
    if cfg.database.createLocally then
      {
        "mysql" = config.services.mysql.settings.mysqld.port;
        "postgresql" = config.services.postgresql.settings.port;
      }
      .${cfg.database.type}
    else
      cfg.database.port;

  # see https://github.com/Dolibarr/dolibarr/blob/develop/htdocs/install/install.forced.sample.php for all possible values
  install = {
    force_install_noedit = 2;
    force_install_main_data_root = "${cfg.stateDir}/documents";
    force_install_nophpinfo = true;
    force_install_lockinstall = "444";
    force_install_distrib = "nixos";
    force_install_type =
      {
        "mysql" = "mysqli";
        "postgresql" = "pgsql";
      }
      .${cfg.database.type};
    force_install_dbserver = cfg.database.host;
    force_install_port = toString dbPort;
    force_install_database = cfg.database.name;
    force_install_databaselogin = cfg.database.user;

    force_install_mainforcehttps = vhostCfg.forceSSL or false;
    force_install_createuser = false;
    force_install_dolibarrlogin = null;
  }
  // optionalAttrs (cfg.database.passwordFile != null) {
    force_install_databasepass = ''file_get_contents("${cfg.database.passwordFile}")'';
  };
in
{
  # interface
  options.services.dolibarr = {
    enable = mkEnableOption "dolibarr";

    package = mkPackageOption pkgs "dolibarr" { };

    domain = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Domain name of your server.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "dolibarr";
      description = ''
        User account under which dolibarr runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the dolibarr application starts.
        :::
      '';
    };

    group = mkOption {
      type = types.str;
      default = "dolibarr";
      description = ''
        Group account under which dolibarr runs.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the dolibarr application starts.
        :::
      '';
    };

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/dolibarr";
      description = ''
        State and configuration directory dolibarr will use.
      '';
    };

    database = {
      type = mkOption {
        type = types.enum [
          "mysql"
          "postgresql"
        ];
        example = "postgresql";
        default = "mysql";
        description = "Database engine to use.";
      };
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
        default = "dolibarr";
        description = "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = "dolibarr";
        description = "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/dolibarr-dbpassword";
        description = "Database password file.";
      };
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };

    settings = mkOption {
      type =
        with types;
        (attrsOf (oneOf [
          bool
          int
          str
        ]));
      default = { };
      description = "Dolibarr settings, see <https://github.com/Dolibarr/dolibarr/blob/develop/htdocs/conf/conf.php.example> for details.";
    };

    nginx = mkOption {
      type = types.nullOr (
        types.submodule (
          lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {
            # enable encryption by default,
            # as sensitive login and Dolibarr (ERP) data should not be transmitted in clear text.
            options.forceSSL.default = true;
            options.enableACME.default = true;
          }
        )
      );
      default = null;
      example = lib.literalExpression ''
        {
          serverAliases = [
            "dolibarr.''${config.networking.domain}"
            "erp.''${config.networking.domain}"
          ];
          enableACME = false;
        }
      '';
      description = ''
        With this option, you can customize an nginx virtual host which already has sensible defaults for Dolibarr.
        Set to {} if you do not need any customization to the virtual host.
        If enabled, then by default, the {option}`serverName` is
        `''${domain}`,
        SSL is active, and certificates are acquired via ACME.
        If this is set to null (the default), no nginx virtualHost will be configured.
      '';
    };

    poolConfig = mkOption {
      type =
        with types;
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
        Options for the Dolibarr PHP pool. See the documentation on [`php-fpm.conf`](https://www.php.net/manual/en/install.fpm.configuration.php)
        for details on configuration directives.
      '';
    };
  };

  # implementation
  config = mkIf cfg.enable (mkMerge [
    {

      assertions = [
        {
          assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
          message = "services.dolibarr.database.user must match services.dolibarr.user if the database is to be automatically provisioned";
        }
      ];

      services.dolibarr.settings = {
        dolibarr_main_url_root = "https://${cfg.domain}";
        dolibarr_main_document_root = "${package}/htdocs";
        dolibarr_main_url_root_alt = "/custom";
        dolibarr_main_data_root = "${cfg.stateDir}/documents";

        dolibarr_main_db_host = cfg.database.host;
        dolibarr_main_db_port = toString dbPort;
        dolibarr_main_db_name = cfg.database.name;
        dolibarr_main_db_prefix = "llx_";
        dolibarr_main_db_user = cfg.database.user;
        dolibarr_main_db_pass = mkIf (cfg.database.passwordFile != null) ''
          file_get_contents("${cfg.database.passwordFile}")
        '';
        dolibarr_main_db_type =
          {
            "mysql" = "mysqli";
            "postgresql" = "pgsql";
          }
          .${cfg.database.type};
        dolibarr_main_db_character_set = mkDefault "utf8";
        dolibarr_main_db_collation = mkDefault "utf8_unicode_ci";

        # Authentication settings
        dolibarr_main_authentication = mkDefault "dolibarr";

        # Security settings
        dolibarr_main_prod = true;
        dolibarr_main_force_https = vhostCfg.forceSSL or false;
        dolibarr_main_restrict_os_commands =
          {
            "mysql" = "${pkgs.mariadb}/bin/mysqldump, ${pkgs.mariadb}/bin/mysql";
            "postgresql" =
              let
                pkg = config.services.postgresql.package;
              in
              "${pkg}/bin/pg_dump, ${pkg}/bin/psql";
          }
          .${cfg.database.type};
        dolibarr_nocsrfcheck = false;
        dolibarr_main_instance_unique_id = ''
          file_get_contents("${cfg.stateDir}/dolibarr_main_instance_unique_id")
        '';
        dolibarr_mailing_limit_sendbyweb = false;
      };

      systemd.tmpfiles.rules = [
        "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group}"
        "d '${cfg.stateDir}/documents' 0750 ${cfg.user} ${cfg.group}"
        "f '${cfg.stateDir}/conf.php' 0660 ${cfg.user} ${cfg.group}"
        "L '${cfg.stateDir}/install.forced.php' - ${cfg.user} ${cfg.group} - ${mkConfigFile "install.forced.php" install}"
      ];

      services.mysql = mkIf (cfg.database.createLocally && cfg.database.type == "mysql") {
        enable = mkDefault true;
        package = mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensurePermissions = {
              "${cfg.database.name}.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };

      services.postgresql = mkIf (cfg.database.createLocally && cfg.database.type == "postgresql") {
        enable = mkDefault true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
        authentication = ''
          host ${cfg.database.name} ${cfg.database.user} localhost trust
        '';
      };

      services.nginx.enable = mkIf (cfg.nginx != null) true;
      services.nginx.virtualHosts."${cfg.domain}" = mkIf (cfg.nginx != null) (
        lib.mkMerge [
          cfg.nginx
          {
            root = lib.mkForce "${package}/htdocs";
            locations."/".index = "index.php";
            locations."~ [^/]\\.php(/|$)" = {
              extraConfig = ''
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                fastcgi_pass unix:${config.services.phpfpm.pools.dolibarr.socket};
              '';
            };
          }
        ]
      );

      systemd.services."phpfpm-dolibarr" = {
        after = lib.optional cfg.database.createLocally dbUnit;
        requires = lib.optional cfg.database.createLocally dbUnit;
      };

      services.phpfpm.pools.dolibarr = {
        inherit (cfg) user group;
        phpPackage = pkgs.php83.buildEnv {
          extensions = { enabled, all }: enabled ++ [ all.calendar ];
          # recommended by Dolibarr web application
          extraConfig = ''
            session.use_strict_mode = 1
            session.cookie_samesite = "Lax"
            ; open_basedir = "${package}/htdocs, ${cfg.stateDir}"
            allow_url_fopen = 0
            disable_functions = "pcntl_alarm, pcntl_fork, pcntl_waitpid, pcntl_wait, pcntl_wifexited, pcntl_wifstopped, pcntl_wifsignaled, pcntl_wifcontinued, pcntl_wexitstatus, pcntl_wtermsig, pcntl_wstopsig, pcntl_signal, pcntl_signal_get_handler, pcntl_signal_dispatch, pcntl_get_last_error, pcntl_strerror, pcntl_sigprocmask, pcntl_sigwaitinfo, pcntl_sigtimedwait, pcntl_exec, pcntl_getpriority, pcntl_setpriority, pcntl_async_signals"
          '';
        };

        settings = {
          "listen.mode" = "0660";
          "listen.owner" = cfg.user;
          "listen.group" = cfg.group;
        }
        // cfg.poolConfig;
      };

      # There are several challenges with Dolibarr and NixOS which we can address here
      # - the Dolibarr installer cannot be entirely automated, though it can partially be by including a file called install.forced.php
      # - the Dolibarr installer requires write access to its config file during installation, though not afterwards
      # - the Dolibarr config file generally holds secrets generated by the installer, though the config file is a PHP file so we can read and write these secrets from an external file
      systemd.services.dolibarr-config = {
        description = "dolibarr configuration file management via NixOS";
        wantedBy = [ "multi-user.target" ];
        after = lib.optional cfg.database.createLocally dbUnit;

        script =
          let
            php = lib.getExe config.services.phpfpm.pools.dolibarr.phpPackage;
          in
          ''
            # extract the 'main instance unique id' secret that the dolibarr installer generated for us, store it in a file for use by our own NixOS generated configuration file
            ${php} -r "include '${cfg.stateDir}/conf.php'; file_put_contents('${cfg.stateDir}/dolibarr_main_instance_unique_id', \$dolibarr_main_instance_unique_id);"

            # replace configuration file generated by installer with the NixOS generated configuration file
            install -m 440 ${mkConfigFile "conf.php" cfg.settings} '${cfg.stateDir}/conf.php'
          '';

        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
          RemainAfterExit = "yes";
        };

        unitConfig = {
          ConditionFileNotEmpty = "${cfg.stateDir}/conf.php";
        };
      };

      users.users.dolibarr = mkIf (cfg.user == "dolibarr") {
        isSystemUser = true;
        group = cfg.group;
      };

      users.groups = optionalAttrs (cfg.group == "dolibarr") {
        dolibarr = { };
      };
    }
    (mkIf (cfg.nginx != null) {
      users.users."${config.services.nginx.group}".extraGroups = mkIf (cfg.nginx != null) [ cfg.group ];
    })
  ]);
}
