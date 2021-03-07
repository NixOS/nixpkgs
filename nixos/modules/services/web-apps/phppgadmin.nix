{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (lib)
    boolToString
    types
    mkIf
    mkEnableOption
    mkDefault
    mkOption
    mkMerge
    mapAttrs
    mkOverride
    recursiveUpdate
    ;

  cfg = config.services.phppgadmin;
  fpm = config.services.phpfpm.pools.phppgadmin;

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

  defaultSettings = {
    default_lang = "auto";
    autocomplete = "default on";
    extra_login_security = true;
    owned_only = false;
    show_comments = true;
    show_advanced = false;
    show_system = false;
    min_password_length = 6;
    left_width = 300;
    theme = "default";
    show_oids = false;
    max_rows = 30;
    max_chars = 50;
    use_xhtml_strict = false;
    help_base = "http://www.postgresql.org/docs/%s/interactive/";
    ajax_refresh = 3;
    plugins = "array()";
    version = 19;
  };

  settings = recursiveUpdate defaultSettings cfg.settings;

  globalSettings = ''
    $conf['default_lang'] = '${toString settings.default_lang}';
    $conf['autocomplete'] = '${toString settings.autocomplete}';
    $conf['extra_login_security'] = ${boolToString settings.extra_login_security};
    $conf['owned_only'] = ${boolToString settings.owned_only};
    $conf['show_comments'] = ${boolToString settings.show_comments};
    $conf['show_advanced'] = ${boolToString settings.show_advanced};
    $conf['show_system'] = ${boolToString settings.show_system};
    $conf['min_password_length'] = ${toString settings.min_password_length};
    $conf['left_width'] = ${toString settings.left_width};
    $conf['theme'] = '${toString settings.theme}';
    $conf['show_oids'] = ${boolToString settings.show_oids};
    $conf['max_rows'] = ${toString settings.max_rows};
    $conf['max_chars'] = ${toString settings.max_chars};
    $conf['use_xhtml_strict'] = ${boolToString settings.use_xhtml_strict};
    $conf['help_base'] = '${toString settings.help_base}';
    $conf['ajax_refresh'] = ${toString settings.ajax_refresh};
    $conf['plugins'] = ${toString settings.plugins};
    $conf['version'] = ${toString settings.version};
    '';

  phpConfig = cfg: pkgs.writeText "config.inc.php" ''
    <?php
    ${toString globalSettings}

    ${toString genServers}

    ${toString cfg.extraSettings}
    ?>
  '';
in {

  # interface
  options = {
    services.phppgadmin = {
      enable = mkEnableOption "phppgadmin";

      package = mkOption {
        type = types.package;
        default = pkgs.phppgadmin;
        description = "Which package to use for the phpPgAdmin instance.";
      };

      phpPackage = mkOption {
        type = types.package;
        default = pkgs.php;
        defaultText = "pkgs.php";
        description = ''
          The PHP package to use for running the PHP-FPM service.
        '';
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
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        };
        description = ''
          Options for the phpmyadmin PHP pool. See the documentation on <literal>php-fpm.conf</literal>
          for details on configuration directives.
        '';
      };

      # descriptions are mostly copy-pasted from https://github.com/phppgadmin/phppgadmin
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

      settings = mkOption {
        type = with types; attrsOf (oneOf [ str int bool ]);
        default = defaultSettings;
        description = ''
          For a description of all options see: https://github.com/phppgadmin/phppgadmin/blob/master/conf/config.inc.php-dist
        '';
      };

      extraSettings = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration added to 'config.inc.php'.
          For a description of all options see: https://github.com/phppgadmin/phppgadmin/blob/master/conf/config.inc.php-dist

          Example:

          $conf['srv_groups'][0]['desc'] = 'group one';
          $conf['srv_groups'][0]['servers'] = '0,1,2';
          $conf['srv_groups'][1]['desc'] = 'group two';
          $conf['srv_groups'][1]['servers'] = '3,1';
          $conf['srv_groups'][2]['desc'] = 'group three';
          $conf['srv_groups'][2]['servers'] = '4';
          $conf['srv_groups'][2]['parents'] = '0,1';

          $conf['servers'][0]['theme']['default'] = 'default';
          $conf['servers'][0]['theme']['user']['specific_user'] = 'default';
          $conf['servers'][0]['theme']['db']['specific_db'] = 'default';
        '';
      };
    };
  };

  # implementation
  config = mkIf cfg.enable {

    assertions = [{
      assertion = config.services.phpfpm.pools.phppgadmin.phpPackage.version < "8" &&
                  config.services.phpfpm.pools.phppgadmin.phpPackage.version >= "7";
      message = "PhpPgAdmin requires PHP7.";
    }];


    users.users.phppgadmin = {
      group = "phppgadmin";
      isSystemUser = true;
    };

    users.groups.phppgadmin.members = [ "phppgadmin" config.services.nginx.user ];

    services.phpfpm = {
      pools.phppgadmin = {
        user = "phppgadmin";
        group = "phppgadmin";
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolSettings;
      };
    };

    services.nginx.enable = mkDefault true;
    services.nginx.virtualHosts.phppgadmin = mkMerge [ cfg.virtualHost {
      root = mkOverride 10 "${pkg cfg}";
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

  meta.maintainers = with lib.maintainers; [ leonardp ];
}
