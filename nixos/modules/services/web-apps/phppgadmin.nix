{ config, lib, pkgs, modulesPath, ... }:

with lib;

let
  cfg = config.services.phppgadmin;
  fpm = config.services.phpfpm.pools.phppgadmin;
  phpPackage = pkgs.php74;

  pkg = cfg: pkgs.stdenv.mkDerivation rec {
    pname = "phppgadmin-with-cfg";
    version = src.version;
    src = cfg.package;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
      ln -s ${phpConfig cfg} $out/conf/config.inc.php
    '';
  };

  # credits to @balsoft
  genServers = builtins.genList (n: let host = builtins.elemAt cfg.dbHosts n; in ''
        $conf['servers'][${toString n}]['desc'] = "${host.desc}";
        $conf['servers'][${toString n}]['host'] = "${host.host}";
        $conf['servers'][${toString n}]['port'] = ${toString host.port};
        $conf['servers'][${toString n}]['sslmode'] = "${host.sslmode}";
        $conf['servers'][${toString n}]['defaultdb'] = "${host.defaultdb}";
        $conf['servers'][${toString n}]['pg_dump_path'] = "${host.pg_dump_path}";
        $conf['servers'][${toString n}]['pg_dumpall_path'] = "${host.pg_dumpall_path}";
      '') (builtins.length cfg.dbHosts);

  phpConfig = cfg: pkgs.writeText "config.inc.php" ''
    <?php
    ${toString genServers}

    //$conf['srv_groups'][0]['desc'] = 'group one';
    //$conf['srv_groups'][0]['servers'] = '0,1,2';
    //$conf['srv_groups'][1]['desc'] = 'group two';
    //$conf['srv_groups'][1]['servers'] = '3,1';
    //$conf['srv_groups'][2]['desc'] = 'group three';
    //$conf['srv_groups'][2]['servers'] = '4';
    //$conf['srv_groups'][2]['parents'] = '0,1';

    //$conf['servers'][0]['theme']['default'] = 'default';
    //$conf['servers'][0]['theme']['user']['specific_user'] = 'default';
    //$conf['servers'][0]['theme']['db']['specific_db'] = 'default';

    $conf['default_lang'] = 'auto';
    $conf['autocomplete'] = 'default on';
    $conf['extra_login_security'] = ${boolToString cfg.extraLoginSecurity};
    $conf['owned_only'] = ${boolToString cfg.ownedOnly};
    $conf['show_comments'] = true;
    $conf['show_advanced'] = false;
    $conf['show_system'] = false;
    $conf['min_password_length'] = 6;
    $conf['left_width'] = 300;
    $conf['theme'] = '${cfg.theme}';
    $conf['show_oids'] = false;
    $conf['max_rows'] = 30;
    $conf['max_chars'] = 50;
    $conf['use_xhtml_strict'] = false;
    $conf['help_base'] = 'http://www.postgresql.org/docs/%s/interactive/';
    $conf['ajax_refresh'] = 3;
    $conf['plugins'] = array();
    $conf['version'] = 19;
    ?>
  '';
in {

  # interface
  # descriptions are mostly copy-pasted from https://github.com/phppgadmin/phppgadmin
  options = {
    services.phppgadmin = {
      enable = mkEnableOption "phppgadmin";

      package = mkOption {
        type = types.package;
        default = pkgs.phppgadmin;
        description = "Which package to use for the phpPgAdmin instance.";
      };

      virtualHost = mkOption {
        type = types.submodule (import (modulesPath + "/services/web-servers/nginx/vhost-options.nix"));
        default = { };
        example = { listen = [ { addr = "0.0.0.0"; port = 9090; } ]; };
        description = ''
          Nginx Virtual Host configuration for <option>services.nginx.virtualHosts.phppgadmin</option>.
        '';
      };

      poolSettings = mkOption {
        type = with types; attrsOf (oneOf [ str int bool ]);
        default = {
          "pm" = "dynamic";
          "pm.max_children" = "3";
          "pm.start_servers" = "1";
          "pm.min_spare_servers" = "1";
          "pm.max_spare_servers" = "2";
          "pm.max_requests" = "100";
        };
        description = ''
          Options for the phpmyadmin PHP pool. See the documentation on <literal>php-fpm.conf</literal>
          for details on configuration directives.
        '';
      };

      dbHosts = mkOption {
        description = "Database connections.";
        example = [
          {
            desc = "local";
          }
          {
            desc = "remote";
            host = "postgres.domain";
            port = 4321;
            sslmode = "require";
            pg_dump_path = "/usr/bin/pg_dump";
            pg_dump_all_path = "/usr/bin/pg_dumpall";
          }
        ];
        type = with types; listOf (submodule {
          options = {
            desc = mkOption {
              type = str;
              default = "PostgreSQL";
              description = "Display name for the server on the login screen.";
            };
            host = mkOption {
              type = str;
              default = "";
              description = ''
                Hostname or IP address for server.  Use "" for UNIX domain socket.
                use "localhost" for TCP/IP connection on this computer";
              '';
            };
            port = mkOption {
              type = int;
              default = 5432;
              description = "Database port on server.";
            };
            sslmode = mkOption {
              type = enum [ "disable" "allow" "prefer" "require" ];
              default = "allow";
              description = ''
                Database SSL mode
                Possible options: disable, allow, prefer, require
                To require SSL on older servers use option: legacy
                To ignore the SSL mode, use option: unspecified
              '';
            };
            defaultdb = mkOption {
              type = str;
              default = "template1";
              description = ''
                Change the default database only if you cannot connect to template1.
                For a PostgreSQL 8.1+ server, you can set this to 'postgres'.
              '';
            };
            pg_dump_path = mkOption {
              type = str;
              default = "/run/current-system/sw/bin/pg_dump";
              description = ''
                Specify the path to the database dump utilities for this server.
                You can set these to "" if no dumper is available.
              '';
            };
            pg_dumpall_path = mkOption {
              type = str;
              default = "/run/current-system/sw/bin/pg_dumpall";
              description = ''
                Specify the path to the database dump utilities for this server.
                You can set these to "" if no dumper is available.
              '';
            };
          };
        });
      };

      extraLoginSecurity = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If extra login security is true, then logins via phpPgAdmin with no
          password or certain usernames (pgsql, postgres, root, administrator)
          will be denied. Only set this false once you have read the FAQ and
          understand how to change PostgreSQL's pg_hba.conf to enable
          passworded local connections.
        '';
      };

      ownedOnly = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Only show owned databases?
          Note: This will simply hide other databases in the list - this does
          not in any way prevent your users from seeing other database by
          other means. (e.g. Run 'SELECT * FROM pg_database' in the SQL area.)
        '';
      };

      theme = mkOption {
        type = with types; enum [ "default" "cappuccino" "gotar" "bootstrap" ];
        default = "default";
        description = ''
          Which look and feel theme to use.
        '';
      };
    };
  };

  # implementation
  config = mkIf cfg.enable {

    users.users.phppgadmin = {
      group = "phppgadmin";
      isSystemUser = true;
    };
    users.groups.phppgadmin.members = [ "phppgadmin" config.services.nginx.user ];

    services.phpfpm = {
      pools.phppgadmin = {
        user = "phppgadmin";
        group = "phppgadmin";
        phpPackage = phpPackage;
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolSettings;
      };
    };

    services.nginx.enable = mkDefault true;

    services.nginx.virtualHosts.phppgadmin = mkMerge [ cfg.virtualHost {
      root = mkForce "${pkg cfg}";
      locations = {
        "/" = {
          extraConfig = ''
            try_files $uri /index.php;
          '';
        };
        "~ \.php$" = {
          extraConfig = ''
              try_files $uri =404;
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${fpm.socket};
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
            '';
        };
      };
    } ];
  };
}
