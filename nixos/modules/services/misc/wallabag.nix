{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wallabag;
in
{
  meta.maintainers = with lib.maintainers; [ skowalak ];

  options.services.wallabag = {
    enable = lib.mkEnableOption "Wallabag";

    package = lib.mkPackageOption pkgs "wallabag" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/wallabag";
      description = "Default Wallabag data folder.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "wallabag";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "wallabag";
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = { };
      description = ''
      '';
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "wallabag";
    };
    nginx = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
      );
      default = { };
      description = ''
        With this option, you can customize an NGINX virtual host which already
        has sensible defaults for Kanboard. Set to `{ }` if you do not need any
        customization for the virtual host. If enabled, then by default, the
        {option}`serverName` is `''${domain}`. If this is set to null (the
        default), no NGINX virtual host will be configured.
      '';
      example = lib.literalExpression ''
        {
          enableACME = true;
          forceHttps = true;
        }
      '';
    };
    phpfpm.settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          int
          str
          bool
        ]);

      default = { };

      description = ''
        Options for kanboard's PHPFPM pool.
      '';
    };

  };
  config = lib.mkIf cfg.enable {
    users = {
      users = lib.mkIf (cfg.user == "wallabag") {
        wallabag = {
          isSystemUser = true;
          group = cfg.group;
          home = cfg.dataDir;
          createHome = true;
        };
      };

      groups = lib.mkIf (cfg.group == "wallabag") {
        wallabag = { };
      };
    };

    services.phpfpm.pools.wallabag = {
      user = cfg.user;
      group = cfg.group;

      settings = lib.mkMerge [
        {
          # TODO(skowalak): check which flags are needed in a typical wallabag config
          "pm" = "dynamic";
          "listen.owner" = "nginx";
          "catch_workers_output" = true;
          "pm.max_children" = "32";
          "pm.start_servers" = "2";
          "pm.min_spare_servers" = "2";
          "pm.max_spare_servers" = "4";
          "pm.max_requests" = "500";
        }
        cfg.phpfpm.settings
      ];

      phpEnv = lib.mkMerge [
        {
          DATA_DIR = cfg.dataDir;
        }
        (lib.mapAttrs (lib.const toString) cfg.settings)
      ];
    };

    services.nginx = lib.mkIf (cfg.nginx != null) {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.domain}" = lib.mkMerge [
        {
          root = lib.mkForce "${cfg.package}/web";
          locations."/".extraConfig = ''
            try_files $uri /app.php$is_args$args;
          '';
          locations."/assets".root = lib.mkForce "${cfg.package}/app/web";
          locations."~ ^/app\\.php(/|$)".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.wallabag.socket};
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            include ${config.services.nginx.package}/conf/fastcgi_params;

            fastcgi_param  SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            internal;
          '';
          locations."~ \\.php$".extraConfig = ''
            return 404;
          '';
          locations."~ \\.(js|css|ttf|woff2?|png|jpe?g|svg)$".extraConfig = ''
            add_header Cache-Control "public, max-age=15778463";
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag none;
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header Referrer-Policy no-referrer;
            access_log off;
          '';
        }
        cfg.nginx
      ];
    };
  };

  # environment.etc."wallabag/parameters.yml" = {
  #   source = pkgs.writeTextFile {
  #     name = "wallabag-config";
  #     text = builtins.toJSON {
  #       parameters = settings;
  #     };
  #   };
  # };

  # systemd.services.phpfpm-bag.serviceConfig = commonServiceConfig;

  # systemd.services.wallabag-install = {
  #   description = "Wallabag install service";
  #   wantedBy = [ "multi-user.target" ];
  #   before = [ "phpfpm-bag.service" ];
  #   after = [ "postgresql.service" ];
  #   path = with pkgs; [
  #     coreutils
  #     php
  #     phpPackages.composer
  #   ];

  #   serviceConfig = {
  #     User = "bag";
  #     Type = "oneshot";
  #   } // commonServiceConfig;

  #   script = ''
  #     if [ ! -f "$STATE_DIRECTORY/installed" ]; then
  #       php ${wallabag}/bin/console --env=prod wallabag:install
  #       touch "$STATE_DIRECTORY/installed"
  #     else
  #       php ${wallabag}/bin/console --env=prod doctrine:migrations:migrate --no-interaction
  #     fi
  #     php ${wallabag}/bin/console --env=prod cache:clear
  #   '';
  # };
}
