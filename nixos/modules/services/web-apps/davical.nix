{ config, lib, pkgs, ... }:
let
  cfg = config.services.davical;
  fpm = config.services.phpfpm.pools.davical;
in
{
  options.services.davical = with lib; {
    enable = mkEnableOption "DAViCal server";
    user = mkOption {
      type = types.str;
      default = "davical";
      description = "DAViCal user on local system";
    };
    group = mkOption {
      type = types.str;
      default = "davical";
      description = "DAViCal group on local system";
    };
    virtualHost = mkOption {
      type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
      example = literalExample ''
        {
          adminAddr = "webmaster@example.org";
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = ''
        Apache configuration can be done by adapting <option>services.httpd.virtualHosts</option>.
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
        Options for the DAViCal PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };
    dbName = mkOption {
      type = types.str;
      default = "davical";
      description = "Database name";
    };
    # This is a user name in the database that DAViCal uses to create and manipulate the table stucture on initialization and upgrades.
    # This user doesn't have a password and is granted "trust" authorization using the postgres authentication configuration option.
    dbAdminUser = mkOption {
      type = types.str;
      default = "davical_dba";
      description = "DAViCal database admin user";
    };
    # This is a user name in the database that DAViCal uses to read and write to the database during regular operations.
    # This user don't have a password and is granted "trust" authorization using the postgres authentication configuration option
    dbAppUser = mkOption {
      type = types.str;
      default = "davical_app";
      description = "DAViCal database app user";
    };
    webAdminPass = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Web administrator login password.  Use <literal>webAdminPassFile</literal> to avoid this
        being world-readable in the <literal>/nix/store</literal>.
        This is only used once when DAViCal is first initialized.  It is simpler to use this option
        than the webAdminPassFile, and you can always change the web administrator password once
        it has been initialized.
      '';
    };
    webAdminPassFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The full path to a file on the target system that contains the website administrator password.
        This file must be readable by the postgres user and will be used to set the web administrator password when
        DAViCal is first initialized.  If this file cannot be read, the davical-init.service will fail.  If this
        happens, simply put the file in place and re-run the service to complete initialization.
      '';
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        $c->sysabbr     = 'DAViCal';
        $c->domain_name = "calendar.example.net";
        $c->admin_email = 'admin@example.net';
        $c->system_name = "NixOS DAViCal Server";
      '';
      description = ''
        Extra configuration options to add to DAViCal's config.php file. Refer to <link xlink:href="http://wiki.davical.org/w/Configuration_settings"/> for supported
        values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !(cfg.webAdminPass != null && cfg.webAdminPassFile != null);
        message = "Please specify no more than one of webAdminPass or webAdminPassFile";
      }
      {
        assertion = !(cfg.webAdminPass == "");
        message = "webAdminPass cannot be empty";
      }
    ];

    services.phpfpm.pools.davical = {
      user = cfg.user;
      group = config.services.httpd.group;
      settings = {
        "listen.owner" = config.services.httpd.user;
        "listen.group" = config.services.httpd.group;
        "php_value[include_path]" = "${pkgs.davical}/share/davical/inc:${pkgs.davical.awl}/share/awl/inc";
        "php_value[magic_quotes_gpc]" = "0";
        "php_value[register_globals]" = "0";
        "php_value[error_reporting]" = "E_ALL & ~E_NOTICE";
        "php_value[default_charset]" = "utf-8";
      } // cfg.poolConfig;
    };

    services.postgresql = {
      enable = true;
      authentication = ''
        local ${cfg.dbName} ${cfg.dbAppUser} trust
        local ${cfg.dbName} ${cfg.dbAdminUser} trust
      '';
    };

    environment.etc.davical.source = pkgs.linkFarm "etc-davical" [
      { name = "config.php";
        path = pkgs.writeText "config.php" (
          ''
            <?php
              $c->pg_connect[] = 'dbname=${cfg.dbName} port=5432 user=${cfg.dbAppUser}';
          '' + cfg.extraConfig + "?>"
        );
      }
    ];

    # This service is used to initialize the DAViCal database when it's first installed, and to upgrade the database
    # when DAViCal is upgraded.
    systemd.services.davical-init = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-davical.service" ];
      after = [ "postgresql.service" ];
      path = with pkgs; [ postgresql (perl.withPackages (ps: with ps; [DBDPg YAML])) ];
      # Install or upgrade the database and use a state file to record its version
      script = let
        stateFilePath = "~/.davical.database.version";
        webAdminPassword = if cfg.webAdminPassFile != null
          then ''"$(<"${toString cfg.webAdminPassFile}")"''
          else if cfg.webAdminPass != null
          then ''"${toString cfg.webAdminPass}"''
          else throw "ERROR: no web admin password specified";
        passwordFilePermissions = if cfg.webAdminPassFile != null
          then ''
            if [ ! -r ${cfg.webAdminPassFile} ]; then
                echo "ERROR: web admin password file ${cfg.webAdminPassFile} cannot be read, refusing to procees"
                echo "Please fix the problem and re-run the initialization service"
                exit 1
            fi
          '' else "";
      in passwordFilePermissions + ''
        if [ ! -e ${stateFilePath} ]; then
            echo "State file does not exist, initializing DAViCal database"
            echo "NOTE: on NixOS ignore messages below about editing pg_hba.conf file"
            if ${pkgs.davical}/share/davical/dba/create-database.sh ${cfg.dbName} ${webAdminPassword} ${cfg.dbAdminUser} ${cfg.dbAppUser}; then
                echo "Database creation successful, setting state file"
                echo ${pkgs.davical.version} > ${stateFilePath}
            else
                echo "ERROR: Database creation failed, not setting state file"
                exit 1
            fi
        elif [ $(echo -e "${pkgs.davical.version}\n$(cat ${stateFilePath})" | sort -Vr | head -n 1) != $(cat ${stateFilePath}) ]; then
            echo "State file exists but is for an older version.  Calling DAViCal upgrade script to upgrade the database."
            if ${pkgs.davical}/share/davical/dba/update-davical-database --dbuser "${cfg.dbAdminUser}" --dbname "${cfg.dbName}" --appuser "${cfg.dbAppUser}" --owner "${cfg.dbAdminUser}"; then
                echo "Database upgrade successful, updating state file"
                echo ${pkgs.davical.version} > ${stateFilePath}
            else
                echo "ERROR: Database upgrade failed, not updating state file"
                exit 1
            fi
        else
            echo "State file exists but is for the same or a newer version.  Not doing anything."
        fi
      '';
      serviceConfig = {
        User = "postgres";
        Group = "postgres";
        Type = "oneshot";
      };
    };

    services.httpd = {
      enable = true;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.${cfg.virtualHost.hostName} = lib.mkMerge [ cfg.virtualHost {
        documentRoot = lib.mkForce "${pkgs.davical}/share/davical/htdocs";
        extraConfig = ''
          Alias /images/ ${pkgs.davical}/share/davical/htdocs/images/
          <Directory "${pkgs.davical}/share/davical">
            <FilesMatch "\.php$">
              <If "-f %{REQUEST_FILENAME}">
                SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
              </If>
            </FilesMatch>
            AllowOverride all
            CGIPassAuth on
            Options -Indexes
            DirectoryIndex index.php index.html
          </Directory>
        '';
      } ];
    };

    users.users.${cfg.user} = lib.mapAttrs (name: lib.mkDefault) {
      description = "DAViCal daemon user";
      group = cfg.group;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = lib.mapAttrs (name: lib.mkDefault) {
    };

  };

}
