{ config, lib, pkgs, options, ... }:
let
  cfg = config.services.dolibarr;
  app = "dolibarr";

  myphp = pkgs.php;
  version = "15.0.3";
  configFile = "/etc/${app}/conf.php";
  dolibarr = with pkgs; stdenvNoCC.mkDerivation {
    pname = "dolibarr-src";
    inherit version;
    src = fetchFromGitHub {
      owner = "Dolibarr";
      repo = "dolibarr";
      rev = version;
      sha256 = "sha256-HMOYj93ZvqM0FQjt313yuGj/r9ELqQlnNkg/CxrBjRM=";
    };
    postPatch = ''
      sed -i \
        -e 's|\$conffile = .*|\$conffile = "${configFile}";|g' \
        -e 's|\$conffiletoshow = .*|\$conffiletoshow = "${configFile}";|g' \
        htdocs/filefunc.inc.php
      sed -i \
        -e 's|\$conffile = .*|\$conffile = "${configFile}";|g' \
        -e 's|\$conffiletoshow = .*|\$conffiletoshow = "${configFile}";|g' \
        htdocs/install/inc.php
    '';
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out"
      cp -r * $out
    '';
  };
  webroot = "${dolibarr}/htdocs";
  passwordPlaceholder = "__PLACEHOLDER_PASSWORD__";
  uniqueIdPlaceholder = "__PLACEHOLDER_UNIQUE_ID__";
in
with lib; {
  options.services.dolibarr = {
    enable = mkEnableOption "Dolibarr ERP &amp; CRM";
    preInstalled = mkEnableOption "Preinstall dolibarr"// {
      description = ''
        Whether to preinstall dolibarr or not.

        <note><para>
          The database is automatically configured with the following credentials:


          <itemizedlist>
            <listitem><para>login is <literal>dolibarrlogin</literal></para></listitem>
            <listitem><para>password is <literal>123dolibarrlogin_pass</literal></para></listitem>
          </itemizedlist>
        </para></note>
      '';
    };
    initialDbPasswordFile = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/run/secrets/dolibarr-db-user-password";
      description = ''
        If not null, the ${app} user will be created in mysql and the plain-text password
        contained in this file will be used to set the password for this user
        Please make sure the root user has access to this file.
      '';
    };
    domain = mkOption {
      type = types.str;
      example = "${app}.mycompany.com";
      description = "Domain to serve on";
    };
  };
  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialDatabases = [
        ({
          name = app;
        } // lib.optionalAttrs cfg.preInstalled {
          # This file can be generated automatically
          # with nixosTests.dolibarr under result/dolibarr-db.sql.
          # The underlying nix test at `nixos/tests/dolibarr.nix`
          # can be easily configured to change the different options
          # provided by selenium to the the install pages.
          schema = ./preinstalled-db.sql;
        })
      ];
    };
    services.phpfpm.pools.${app} = {
      user = app;
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
      phpEnv = {
        "PATH" = lib.makeBinPath [ myphp ];
      };
    };
    services.nginx = {
      enable = true;
      virtualHosts."${app}.com" = {
        listen = [{
          addr = "0.0.0.0";
          port = 80;
        }];
        root = "${webroot}";
        locations."/" = {
          tryFiles = "$uri $uri/ $uri.php";
          index = "index.php";
        };
        locations."~ \\.php$" = {
          tryFiles = "$uri =404";
          fastcgiParams = {
            SCRIPT_FILENAME = "$document_root$fastcgi_script_name";
            SERVER_NAME = "$http_host";
            PHP_VALUE = "upload_max_filesize=5M \\n post_max_size=5M";
          };
          extraConfig = ''
            fastcgi_pass             unix:${config.services.phpfpm.pools.${app}.socket};
            fastcgi_index            index.php;
            include                  ${pkgs.nginx}/conf/fastcgi_params;
            include                  ${pkgs.nginx}/conf/fastcgi.conf;
            fastcgi_intercept_errors on;
            fastcgi_split_path_info  ^(.+\.php)(.+)$;
          '';
        };
      };
    };

    systemd.services.dolibarr-mysql-db-init = {
      description = "Initialize mysql db for ${app}";
      wants = [ "mysql.service" ];
      after = [ "mysql.service" ];
      serviceConfig = let
        script =  let
          mysqlPasswordActivation = let
              initialScript = ''
                CREATE USER IF NOT EXISTS '${app}'@'localhost' IDENTIFIED BY '${passwordPlaceholder}';
                GRANT ALL PRIVILEGES ON ${app}.* TO '${app}'@'localhost';
              '';
            in (if (cfg.initialDbPasswordFile != null) then ''
              tmp_script_file=$(mktemp)
              echo ${escapeShellArg initialScript} > $tmp_script_file
              ${pkgs.replace-secret}/bin/replace-secret '${passwordPlaceholder}' '${cfg.initialDbPasswordFile}' $tmp_script_file
              cat $tmp_script_file | ${config.services.mysql.package}/bin/mysql -u root -N
              rm -f $tmp_script_file
            '' else "");
        in ''
          #!${pkgs.runtimeShell}
          # Setup database password
          echo 'SELECT User FROM mysql.user WHERE User = "${app}";' | ${config.services.mysql.package}/bin/mysql -u root -N | grep '${app}'
          if [ ! $? = 0 ]; then
            ${mysqlPasswordActivation}
          fi
        '';
        startScript = pkgs.writeScriptBin "${app}-mysql-db-init-start" script;
      in {
        Type = "oneshot";
        ExecStart = "${startScript}/bin/${app}-mysql-db-init-start";
      };
    };

    systemd.services.nginx = {
      wants = [ "${app}-mysql-db-init.service" ];
      after = [ "${app}-mysql-db-init.service" ];
    };
    systemd.services.phpfpm-dolibarr = {
      serviceConfig.ReadWriteDirectories = [
        "/etc/${app}"
        "/var/lib/${app}/documents"
      ];
    };

    system.activationScripts.dolibarr-init-script = let
      initConfig = ''
        <?php

        $dolibarr_main_url_root='http://${cfg.domain}';
        $dolibarr_main_document_root='${webroot}';
        $dolibarr_main_url_root_alt='/custom';
        $dolibarr_main_document_root_alt='${webroot}/custom';
        $dolibarr_main_data_root='/var/lib/${app}/documents';
        $dolibarr_main_db_host='localhost';
        $dolibarr_main_db_port='3306';
        $dolibarr_main_db_name='${app}';
        $dolibarr_main_db_prefix='llx_';
        $dolibarr_main_db_user='${app}';
        $dolibarr_main_db_pass='${passwordPlaceholder}';
        $dolibarr_main_db_type='mysqli';
        $dolibarr_main_db_character_set='utf8';
        $dolibarr_main_db_collation='utf8_unicode_ci';
        $dolibarr_main_authentication='${app}';
        $dolibarr_main_prod='0';
        $dolibarr_main_force_https='0';
        $dolibarr_main_restrict_os_commands='mysqldump, mysql, pg_dump, pgrestore';
        $dolibarr_nocsrfcheck='0';
        $dolibarr_main_instance_unique_id='${uniqueIdPlaceholder}';
        $dolibarr_mailing_limit_sendbyweb='0';
        $dolibarr_main_distrib='standard';
      '';
    in stringAfter [ "etc" "groups" "users" ] ''
      # Setup folders in /var/lib/${app}/documents
      mkdir -p /var/lib/${app}/documents/{mycompany,medias,users,facture,propale,ficheinter,produit,doctemplates}
      chown -R ${app}:${app} /var/lib/${app}
      chmod -R 0700 /var/lib/${app}

      # Setup config file
      tmp_hash=$(mktemp)
      head -n 100 /dev/random| md5sum | cut -d' ' -f1 > $tmp_hash
      [ ! -f /etc/${app}/conf.php ] && \
        echo ${escapeShellArg initConfig}  > /etc/${app}/conf.php && \
        ${pkgs.replace-secret}/bin/replace-secret '${passwordPlaceholder}' '${cfg.initialDbPasswordFile}' /etc/${app}/conf.php && \
        ${pkgs.replace-secret}/bin/replace-secret '${uniqueIdPlaceholder}' $tmp_hash /etc/${app}/conf.php && \
        chown ${app}:${app} /etc/${app}/conf.php && \
        chmod 0600 /etc/${app}/conf.php
      rm -f $tmp_hash
    '';

    users.users.${app} = {
      isSystemUser = true;
      createHome = true;
      home = "/etc/${app}";
      group = app;
    };
    users.groups.${app} = { };
    networking.firewall.allowedTCPPorts = [ 80 ];
    environment.systemPackages = [ myphp ];
  };
}
