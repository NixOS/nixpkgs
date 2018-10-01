{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.roundcube;
in
{
  options.services.roundcube = {
    enable = mkEnableOption "Roundcube";

    listenAddress = mkOption {
      type = types.str;
      default = 127.0.0.1;
      description = "Listening address";
    };

    listenPort = mkOption {
      type = types.int;
      default = 80;
      description = "Listening port";
    };
    
    subDomain = mkOption {
      type = types.str;
      example = "webmail";
      description = "Sub-domain to use which is the name of the nginx vhost";
    };
    
    extraConfig = mkOption {
      type = types.str;
      default = ''
        <?php

        $config = array();
        $config['db_dsnw'] = 'pgsql://roundcube:pass@localhost/roundcubemail';
        $config['db_prefix'] = 'rc';
        $config['default_host'] = 'tls://%h';
        $config['smtp_server'] = 'tls://%h';
        $config['smtp_user'] = '%u';
        $config['smtp_pass'] = '%p';

        $config['max_message_size'] = '25M';
      '';
      description = "Configuration for roundcube webmail instance";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."roundcube/config.inc.php".text = cfg.extraConfig;

    services.nginx.virtualHosts = {
      "${cfg.subDomain}" = {
        listen = [ { addr = cfg.listenAddress; port = cfg.listenPort; } ];
        locations."/" = {
          root = pkgs.roundcube;
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

    services.phpfpm.poolConfigs.${cfg.subDomain} = ''
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
  };
}
