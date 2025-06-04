{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.rutorrent;

  rtorrentPluginDependencies = with pkgs; {
    _task = [ procps ];
    unpack = [
      unzip
      unrar
    ];
    rss = [ curl ];
    mediainfo = [ mediainfo ];
    spectrogram = [ sox ];
    screenshots = [ ffmpeg ];
  };

  phpPluginDependencies = with pkgs; {
    _cloudflare = [ python3 ];
  };

  getPluginDependencies = dependencies: concatMap (p: attrByPath [ p ] [ ] dependencies);

in
{
  options = {
    services.rutorrent = {
      enable = mkEnableOption "ruTorrent";

      hostName = mkOption {
        type = types.str;
        description = "FQDN for the ruTorrent instance.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/rutorrent";
        description = "Storage path of ruTorrent.";
      };

      user = mkOption {
        type = types.str;
        default = "rutorrent";
        description = ''
          User which runs the ruTorrent service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "rutorrent";
        description = ''
          Group which runs the ruTorrent service.
        '';
      };

      rpcSocket = mkOption {
        type = types.str;
        default = config.services.rtorrent.rpcSocket;
        defaultText = "config.services.rtorrent.rpcSocket";
        description = ''
          Path to rtorrent rpc socket.
        '';
      };

      plugins = mkOption {
        type = with types; listOf (either str package);
        default = [ "httprpc" ];
        example = literalExpression ''[ "httprpc" "data" "diskspace" "edit" "erasedata" "theme" "trafic" ]'';
        description = ''
          List of plugins to enable. See the list of <link xlink:href="https://github.com/Novik/ruTorrent/wiki/Plugins#currently-there-are-the-following-plugins">available plugins</link>. Note: the <literal>unpack</literal> plugin needs the nonfree <literal>unrar</literal> package.
          You need to either enable one of the <literal>rpc</literal> or <literal>httprpc</literal> plugin or enable the <xref linkend="opt-services.rutorrent.nginx.exposeInsecureRPC2mount"/> option.
        '';
      };

      poolSettings = mkOption {
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
          Options for ruTorrent's PHP pool. See the documentation on <literal>php-fpm.conf</literal> for details on configuration directives.
        '';
      };

      nginx = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable nginx virtual host management.
            Further nginx configuration can be done by adapting <literal>services.nginx.virtualHosts.&lt;name&gt;</literal>.
            See <xref linkend="opt-services.nginx.virtualHosts"/> for further information.
          '';
        };

        exposeInsecureRPC2mount = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If you do not enable one of the <literal>rpc</literal> or <literal>httprpc</literal> plugins you need to expose an RPC mount through scgi using this option.
            Warning: This allow to run arbitrary commands, as the rtorrent user, so make sure to use authentification. The simplest way would be to use the <literal>services.nginx.virtualHosts.&lt;name&gt;.basicAuth</literal> option.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions =
        let
          usedRpcPlugins = intersectLists cfg.plugins [
            "httprpc"
            "rpc"
          ];
        in
        [
          {
            assertion = (length usedRpcPlugins < 2);
            message = "Please specify only one of httprpc or rpc plugins";
          }
          {
            assertion = !(length usedRpcPlugins > 0 && cfg.nginx.exposeInsecureRPC2mount);
            message = "Please do not use exposeInsecureRPC2mount if you use one of httprpc or rpc plugins";
          }
        ];

      warnings =
        let
          nginxVhostCfg = config.services.nginx.virtualHosts."${cfg.hostName}";
        in
        [ ]
        ++ (optional
          (
            cfg.nginx.exposeInsecureRPC2mount
            && (nginxVhostCfg.basicAuth == { } || nginxVhostCfg.basicAuthFile == null)
          )
          ''
            You are using exposeInsecureRPC2mount without using basic auth on the virtual host. The exposed rpc mount allow for remote command execution.

            Please make sure it is not accessible from the outside.
          ''
        );

      systemd = {
        services = {
          rtorrent.path = getPluginDependencies rtorrentPluginDependencies cfg.plugins;
          rutorrent-setup =
            let
              rutorrentConfig = pkgs.writeText "rutorrent-config.php" ''
                <?php
                  // configuration parameters

                  // for snoopy client
                  @define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36', true);
                  @define('HTTP_TIME_OUT', 30, true);	// in seconds
                  @define('HTTP_USE_GZIP', true, true);
                  $httpIP = null;				// IP string. Or null for any.
                  $httpProxy = array
                  (
                    'use' 	=> false,
                    'proto'	=> 'http',		// 'http' or 'https'
                    'host'	=> 'PROXY_HOST_HERE',
                    'port'	=> 3128
                  );

                  @define('RPC_TIME_OUT', 5, true);	// in seconds

                  @define('LOG_RPC_CALLS', false, true);
                  @define('LOG_RPC_FAULTS', true, true);

                  // for php
                  @define('PHP_USE_GZIP', false, true);
                  @define('PHP_GZIP_LEVEL', 2, true);

                  $schedule_rand = 10;			// rand for schedulers start, +0..X seconds

                  $do_diagnostic = true;
                  $log_file = '${cfg.dataDir}/logs/errors.log';		// path to log file (comment or leave blank to disable logging)

                  $saveUploadedTorrents = true;		// Save uploaded torrents to profile/torrents directory or not
                  $overwriteUploadedTorrents = false;     // Overwrite existing uploaded torrents in profile/torrents directory or make unique name

                  $topDirectory = '/';			// Upper available directory. Absolute path with trail slash.
                  $forbidUserSettings = false;

                  $scgi_port = 0;
                  $scgi_host = "unix://${cfg.rpcSocket}";

                  $XMLRPCMountPoint = "/RPC2";		// DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!

                  $throttleMaxSpeed = 327625*1024;

                  $pathToExternals = array(
                    "php" 	=> "${pkgs.php82}/bin/php",			// Something like /usr/bin/php. If empty, will be found in PATH.
                    "curl"	=> "${pkgs.curl}/bin/curl",			// Something like /usr/bin/curl. If empty, will be found in PATH.
                    "gzip"	=> "${pkgs.gzip}/bin/gzip",			// Something like /usr/bin/gzip. If empty, will be found in PATH.
                    "id"	=> "${pkgs.coreutils}/bin/id",			// Something like /usr/bin/id. If empty, will be found in PATH.
                    "stat"	=> "${pkgs.coreutils}/bin/stat",			// Something like /usr/bin/stat. If empty, will be found in PATH.
                    "pgrep" => "${pkgs.procps}/bin/pgrep",  // TODO why can't we use phpEnv.PATH
                  );

                  $localhosts = array( 			// list of local interfaces
                    "127.0.0.1",
                    "localhost",
                  );

                  $profilePath = '${cfg.dataDir}/share';		// Path to user profiles
                  $profileMask = 0770;			// Mask for files and directory creation in user profiles.
                  // Both Webserver and rtorrent users must have read-write access to it.
                  // For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

                  $tempDirectory = null;			// Temp directory. Absolute path with trail slash. If null, then autodetect will be used.

                  $canUseXSendFile = false;		// If true then use X-Sendfile feature if it exist

                  $locale = "UTF8";
              '';
            in
            {
              wantedBy = [ "multi-user.target" ];
              before = [ "phpfpm-rutorrent.service" ];
              script = ''
                ln -sf ${pkgs.rutorrent}/{css,images,js,lang,index.html} ${cfg.dataDir}/
                mkdir -p ${cfg.dataDir}/{conf,logs,plugins} ${cfg.dataDir}/share/{settings,torrents,users}
                ln -sf ${pkgs.rutorrent}/conf/{access.ini,plugins.ini} ${cfg.dataDir}/conf/
                ln -sf ${rutorrentConfig} ${cfg.dataDir}/conf/config.php

                cp -r ${pkgs.rutorrent}/php ${cfg.dataDir}/

                ${optionalString (cfg.plugins != [ ])
                  ''cp -r ${
                    concatMapStringsSep " " (p: "${pkgs.rutorrent}/plugins/${p}") cfg.plugins
                  } ${cfg.dataDir}/plugins/''
                }

                chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}/{conf,share,logs,plugins}
                chmod -R 755 ${cfg.dataDir}/{conf,share,logs,plugins}
              '';
              serviceConfig.Type = "oneshot";
            };
        };

        tmpfiles.rules = [ "d '${cfg.dataDir}' 0775 ${cfg.user} ${cfg.group} -" ];
      };

      users.groups."${cfg.group}" = { };

      users.users = {
        "${cfg.user}" = {
          home = cfg.dataDir;
          group = cfg.group;
          extraGroups = [ config.services.rtorrent.group ];
          description = "ruTorrent Daemon user";
          isSystemUser = true;
        };

        "${config.services.rtorrent.user}" = {
          extraGroups = [ cfg.group ];
        };
      };
    }

    (mkIf cfg.nginx.enable (mkMerge [
      {
        services = {
          phpfpm.pools.rutorrent =
            let
              envPath = lib.makeBinPath (getPluginDependencies phpPluginDependencies cfg.plugins);
              pool = {
                user = cfg.user;
                group = config.services.rtorrent.group;
                settings =
                  mapAttrs (name: mkDefault) {
                    "listen.owner" = config.services.nginx.user;
                    "listen.group" = config.services.nginx.group;
                  }
                  // cfg.poolSettings;
              };
            in
            if (envPath == "") then pool else pool // { phpEnv.PATH = envPath; };

          nginx = {
            enable = true;
            virtualHosts = {
              ${cfg.hostName} = {
                root = cfg.dataDir;
                locations = {
                  "~ [^/]\\.php(/|$)" = {
                    extraConfig = ''
                      fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                      if (!-f $document_root$fastcgi_script_name) {
                        return 404;
                      }

                      # Mitigate https://httpoxy.org/ vulnerabilities
                      fastcgi_param HTTP_PROXY "";

                      fastcgi_pass unix:${config.services.phpfpm.pools.rutorrent.socket};
                      fastcgi_index index.php;

                      include ${pkgs.nginx}/conf/fastcgi.conf;
                    '';
                  };
                };
              };
            };
          };
        };
      }

      (mkIf cfg.nginx.exposeInsecureRPC2mount {
        services.nginx.virtualHosts."${cfg.hostName}".locations."/RPC2" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/scgi_params;
            scgi_pass unix:${cfg.rpcSocket};
          '';
        };

        services.rtorrent.group = "nginx";
      })
    ]))
  ]);
}
