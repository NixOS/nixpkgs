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
    
    domain = mkOption {
      type = types.str;
      example = "webmail.domain.tld";
      description = "Sub-domain to use";
    };
    
    extraConfig = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.etc."roundcube/config.inc.php".text = cfg.extraConfig;

    services.nginx.virtualHosts = {
      "roundcube" = {
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
  };
}
