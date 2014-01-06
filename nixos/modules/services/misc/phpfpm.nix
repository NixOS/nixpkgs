{ config, pkgs, ... }:

/*

What does this php-fpm module provide?

Short intro: php-fpm means running PHP outside of apache, with proper linux
user id/group. The php-fdpm daemon will spawn/kill processes as needed.
Comparison chart: http://php-fpm.org/about/#why

How does it work? One php-fpm daemon supervises multiple pools.
However some options like xdebug cannot be configured for an individual pool,
thus if you want one project to be debugcgable you have to create a new
config/daemon pair.

This is what this module is about:
You feed in a list of PHP pool configurations - and the module will group
groupable pools so that they can be supervisd by the same daemon.
Eg if you enable xdebug for one user you'll get two php-fpm services
automatically and everything should just work.

Now that systemd exists each daemon has
- a name ( .service file)
- many pools (each has a socket clients like apache connect to)

And that's what the functions daemonIdFun, socketPathFun are about: given a
configuration they derive a name.  If you know that you're using one PHP-5.3
configuration you can return "5.3", however you must ensure that different
daemon configs don't get the same name !  Thus the default implementation is
using a short hash based on the configuration.  Downside is that log file names
change if you configure PHP differently.

Obviously the socket paths are used by the systemd configuration and by the
apache/lighthttpd/nginx web server configurations.

simple usage example illustrating how you can access the same local web applications
using two different domains php53 and php54 to test both versions, but
debugging is only enable for php 5.3

    let

        phpfpmPools =
        let environment = {
          # LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
        };
        in {
            "php54" = {
              daemonCfg.php = pkgs.php5_4fpm;
              # daemonCfg.id = "5.4"; # optional
              poolItemCfg = {
               inherit environment;
               user  = "user";
               group  = "users";
               listen = { owner = config.services.httpd.user; group = config.services.httpd.group; mode = "0700"; };
               slowlog = "/pr/www/slow-log-5.4";
              };
            };

            "php53" = rec {
              daemonCfg.php = pkgs.php5_3fpm;
              daemonCfg.xdebug = { enable = true; remote_port = "9000"; };
              daemonCfg.phpIniLines = ''
              additional php ini lines
              '';
              # daemonCfg.id = "5.3"; # optional
              poolItemCfg = {
               # inherit environment;
               user  = "user";
               group  = "users";
               listen = { owner = config.services.httpd.user; group = config.services.httpd.group; mode = "0700"; };
               slowlog = "/pr/www/slow-log-5.3";
            };
        };

    in

    {pkgs , config, ...} : {

      services.phpfpm.pools = lib.attrValues phpfpmPools;

      httpd.extraConfig = ''
          FastCGIExternalServer /dev/shm/php5.3.fcgi -socket ${config.services.phpfpm.socketPathFun phpfpmPools.php53} -flush -idle-timeout 300
          FastCGIExternalServer /dev/shm/php5.4.fcgi -socket ${config.services.phpfpm.socketPathFun phpfpmPools.php54} -flush -idle-timeout 300
      '';

      httpd.virtualHosts =
           (
           map (php: let documentRoot = "/pr/www"; in {
             enable = true;
             documentRoot = documentRoot;
             hostName = php.domain;
            extraConfig = ''
            RewriteEngine On

            AddType application/x-httpd-php .php
            AddType application/x-httpd-php .php5
            Action application/x-httpd-php /x/php.fcgi
            Alias /x/php.fcgi /dev/shm/php${php.version}.fcgi

            <Directory ${documentRoot}>
               DirectoryIndex index.php index.html
               Options +ExecCGI
               Order allow,deny
               Allow from all
               AllowOverride All
            </Directory>

            '';
           }) [
            { domain = "php53"; version = "5.3"; }
            { domain = "php54"; version = "5.4"; }
           ]
           );

    }

*/


let
  inherit (builtins) listToAttrs head baseNameOf unsafeDiscardStringContext toString;
  inherit (pkgs.lib) mkOption mkIf mkMerge mergeAttrs foldAttrs attrValues
                    mapAttrs catAttrs fold optionalString;

  cfg =  config.services.phpfpm;

  phpIniFile =
    {item, phpIniLines ? "", name}:
      pkgs.runCommand name { inherit phpIniLines; }
        "cat ${item.daemonCfg.php}/etc/php-recommended.ini > $out; echo \"$phpIniLines\" >> $out"
      ;

  preparePool = item: # item = item of phpfpm.pools
    let
      enableXdebug = item.daemonCfg.xdebug.enable or false;
      profileDir = item.daemonCfg.xdebug.profileDir or (id: "/tmp/xdebug-profiler-dir-${id}");
      xd = if enableXdebug
        then
          let remote_host = item.xdebug.remote_host or "127.0.0.1";
              remote_port = builtins.toString item.xdebug.remote_port or 9000;
           in {
             idAppend = "-xdebug";
             phpIniLines = ''
              zend_extension="${item.daemonCfg.php.xdebug}/lib/xdebug.so"
              zend_extension_ts="${item.daemonCfg.php.xdebug}/lib/xdebug.so"
              zend_extension_debug="${item.daemonCfg.php.xdebug}/lib/xdebug.so"
              xdebug.remote_enable=true
              xdebug.remote_host=${remote_host}
              xdebug.remote_port=${remote_port}
              xdebug.remote_handler=dbgp
              xdebug.profiler_enable=0
              xdebug.remote_mode=req
             '';
           }
        else {
          idAppend = "";
          phpIniLines = "";
        };
      phpIniLines =
          xd.phpIniLines
          + (item.daemonCfg.phpIniLines or "");


      # using phpIniLines create a cfg-id
      iniId = builtins.substring 0 5 (builtins.hashString "sha256" (unsafeDiscardStringContext phpIniLines))
              +xd.idAppend;

      phpIni = (item.daemonCfg.phpIniFile or phpIniFile) {
        inherit item;
        name = "php-${iniId}.ini";
        phpIniLines =
          phpIniLines
          + optionalString enableXdebug "\nprofiler_output_dir = \"${item.daemonCfg.xdebug.profiler_output_dir or (profileDir iniId)}\;";
      };

      # [ID] see daemonIdFun
      id = item.daemonCfg.id or "${item.daemonCfg.php.id}-${iniId}";
      phpIniName = baseNameOf (unsafeDiscardStringContext item.phpIni);
    in item // {
        daemonCfg = item.daemonCfg // {
          inherit phpIniName phpIni id;
        };
      };


  phpFpmDaemons =

    let nv = name: value: listToAttrs [{ inherit name value; }];
        poolsWithIni = map preparePool cfg.pools;
        # group pools by common php and php ini config
        poolsByPHP = foldAttrs (n: a: [n] ++ a) [] (map (p: nv "${p.daemonCfg.id}" p) poolsWithIni);
        toDaemon = name: pools:
            let h = head pools;
            in h.daemonCfg.php.system_fpm_config
                 { # daemon config
                   # TODO make option or such by letting user set these by php.id attr or such
                   log_level = "notice";
                   emergency_restart_threshold = "10";
                   emergency_restart_interval = "1m";
                   process_control_timeout = "5s";
                   inherit (h.daemonCfg) id phpIni phpIniLines;
                 }
                 # pools
                 (map (p:
                   let socketPath = cfg.socketPathFun p;
                   in p.poolItemCfg
                      // {
                      listen_address = socketPath;
                      name = builtins.baseNameOf socketPath;
                    })
                  pools);
    in attrValues (mapAttrs toDaemon poolsByPHP);

in {

  imports = [];

  options = {
    services.phpfpm = {

      enable = mkOption {
        default = true;
        description = "Whether to enable the PHP FastCGI Process Manager. With empty pool this should have no effect";
      };

      stateDir = mkOption {
        default = "/var/run/phpfpm";
        description = "State directory with PID and socket files.";
      };

      logDir = mkOption {
        default = "/var/log/phpfpm";
        description = "Directory where to put in log files.";
      };

      daemonIdFun = mkOption {
        description = "Function returning service name based on php compilation options, php ini file";
        default = pool: (preparePool pool).daemonCfg.id;
      };

      socketPathFun = mkOption {
        description = "Function returning socket path by pool to which web servers connect to.";
        default = pool:
          let pool_h = builtins.substring 0 8 (builtins.hashString "sha256" (builtins.toXML pool.poolItemCfg));
          in "/dev/shm/php-fpm-${cfg.daemonIdFun pool}-${pool_h}";
      };

      pools = mkOption {
        default = [];
        example = [
          rec {

            ### php-fpm daemon options: If contents differ multiple daemons will be started
            daemonCfg = {

              ### id
              # optional:
              # An ID based on the PHP configuration is generated automatically, see [ID] and daemonIdFun
              # id = "php-5.3"
              # this id is used to make the systemd units and the socket paths unique
              # see daemonIdFun etc.

              # php version, must support fpm, thus must have a system_fpm_config attr
              php = pkgs.php5_2fpm.override {};

              # optional: append addditional php.ini lines.

              # Please note that most options can be set by using etxraLines in
              # the pool configuration like this:
              #   php_flag[name]=on/off
              #   php_admin_value[str_option]="127.0.0.1"
              # which should be preferred so that less php-fpm daemons have to be started
              # These lines are appended to the default configuartion shipping with PHP
              # unless phpIniFile is given
              #
              # phpIniLines appends lines to the default php.ini file shipping with PHP.
              # You can override everything by either setting
              # - phpIniFile (function returning file, see sample in this file)
              # - phpIni (must be a file), eg phpIniFile = pkgs.writeFile ...
              phpIniLines = ''
              '';

              # optional: enable xdebug, if set additional phpIniLines will be created
              # xdebug can't be configured per pool, see: https://bugs.php.net/bug.php?id=54824
              xdebug = {
                enable = true;
                # optional names:
                # remote_host = "127.0.0.1";
                # remote_port = 9000;
                # profileDir = id: "/tmp/xdebug-profiler-dir-${id}"; # setting profiler_output_dir
              };

            };

            ### php-fpm per pool options
            poolItemCfg = {

              # pool config, see system_fpm_config implementation in nixpkgs
              slowlog = ""; # must be writeable by the user/group of the php process?

              user = "user";
              group = "group";
              # listen_adress will be set automatically by socketPathFun
              listen = { owner = config.services.httpd.user; group = config.services.httpd.group; mode = "0700"; };

              pm = {
                value = "dynamic";
                max_children = 400;
                min_spare_servers = 10;
                max_spare_servers = 30;
              };

            };
          }
        ];

        description = ''
          Specify the pools the FastCGI Process Manager should manage.
          For each specific PHP and phpIni derivation combination a new
          php-fpm pool has to be created ..

          This is specified by using an attribute set which maps roughly 1:1
          to ini-file syntax, with the exception that the main value of a
          namespace has to be specified by an attribute called 'value'.

          In addition, attributes called 'env' or starting with 'php_' are
          formatted with square brackets, like for example 'env[TMP] = /tmp',
          which corresponds to 'env.TMP = "/tmp"'.

          The php-fpm daemon must run as root, because it must switch user for
          worker threads ..
        '';
      };

    };
  };

  # config = mkIf cfg.enable (mkMerge phpFpmDaemons);
  # is too strict, need to evaluate "config", so pick attrs which are used only
  config = {
    environment.etc = mkMerge (catAttrs "etc" (catAttrs "environment" phpFpmDaemons));
    systemd = mkMerge (catAttrs "systemd" phpFpmDaemons);
  };
}
