{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.baikal;
  # just nginx for now, see wordpress.nix for future potential
  webserver = config.services.nginx;

  pkg = cfg.package.override {
    inherit (cfg) dataDir configDir;
  };

  user = "baikal";
  group = webserver.group;

in {
  options.services.baikal = {
    enable = mkEnableOption (lib.mdDoc "Baïkal is a Calendar+Contacts server ");

    package = mkOption {
      type = types.package;
      default = pkgs.baikal;
      defaultText = literalExpression "pkgs.baikal";
      description = lib.mdDoc "Which baikal package to use.";
    };

    configDir = mkOption {
      type = types.path;
      default = "/etc/baikal/";
      description = lib.mdDoc ''
        Baikal configuration directory. Mostly managed via admin panel.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/baikal/";
      description = lib.mdDoc ''
        Baikal data directory.
      '';
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      example = "dav.example.com";
      description = lib.mdDoc ''
        The hostname to serve baikal on.
      '';
    };

    nginx = mkOption {
      type = types.submodule (
        recursiveUpdate
        (import ../web-servers/nginx/vhost-options.nix {inherit config lib;}) {}
      );
      default = {};
      example = ''
        {
          # To enable encryption and let let's encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = lib.mdDoc ''
        With this option, you can customize the nginx virtualHost settings.
      '';
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [str int bool]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = lib.mdDoc ''
        Options for the baikal PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.${user} = {
      isSystemUser = true;
      group = group;
    };

    services.phpfpm.pools.baikal= {
      inherit user group;
      # phpOptions = ''
      #   log_errors = on
      # '';
      settings = {
        # "listen.mode" = "0660";
        "listen.owner" = user;
        "listen.group" = group;
      } // cfg.poolConfig;
    };

    systemd.services."phpfpm-baikal".serviceConfig.ReadWritePaths = [
        cfg.dataDir
        cfg.configDir
    ];

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.hostname} = {
        serverName = cfg.hostname;
        root = "${pkg}/html/";
        extraConfig = ''
          index index.php;
          rewrite ^/.well-known/caldav /dav.php redirect;
          rewrite ^/.well-known/carddav /dav.php redirect;
          charset utf-8;
        '';
        locations = {
          "~ ^(.+\\.php)(.*)$" = {
              # try_files $fastcgi_script_name =404;
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.baikal.socket};
              fastcgi_split_path_info  ^(.+\.php)(.*)$;
              fastcgi_param  PATH_INFO        $fastcgi_path_info;
              fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
              include ${config.services.nginx.package}/conf/fastcgi_params;

              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              include ${config.services.nginx.package}/conf/fastcgi.conf;
            '';
          };
          "~ /(\\.ht|Core|Specific|config)" = {
            extraConfig = ''
             deny all;
             return 404;
            '';
          };
        };
      };
    };
  };
}
