{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kanboard;

  toStringAttrs = lib.mapAttrs (lib.const toString);
in
{
  meta.maintainers = with lib.maintainers; [ yzx9 ];

  options.services.kanboard = {
    enable = lib.mkEnableOption "Kanboard";

    package = lib.mkPackageOption pkgs "kanboard" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/kanboard";
      description = "Default data folder for Kanboard.";
      example = "/mnt/kanboard";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "kanboard";
      description = "User under which Kanboard runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "kanboard";
      description = "Group under which Kanboard runs.";
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
        Customize the default settings, refer to <https://github.com/kanboard/kanboard/blob/main/config.default.php>
        for details on supported values.
      '';
    };

    # Nginx
    domain = lib.mkOption {
      type = lib.types.str;
      default = "kanboard";
      description = "FQDN for the Kanboard instance.";
      example = "kanboard.example.org";
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
      users = lib.mkIf (cfg.user == "kanboard") {
        kanboard = {
          isSystemUser = true;
          group = cfg.group;
          home = cfg.dataDir;
          createHome = true;
        };
      };

      groups = lib.mkIf (cfg.group == "kanboard") {
        kanboard = { };
      };
    };

    services.phpfpm.pools.kanboard = {
      user = cfg.user;
      group = cfg.group;

      settings = lib.mkMerge [
        {
          "pm" = "dynamic";
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
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
        { DATA_DIR = cfg.dataDir; }
        (toStringAttrs cfg.settings)
      ];
    };

    services.nginx = lib.mkIf (cfg.nginx != null) {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.domain}" = lib.mkMerge [
        {
          root = lib.mkForce "${cfg.package}/share/kanboard";
          locations."/".extraConfig = ''
            rewrite ^ /index.php;
          '';
          locations."~ \\.php$".extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.kanboard.socket};
            include ${config.services.nginx.package}/conf/fastcgi.conf;
            include ${config.services.nginx.package}/conf/fastcgi_params;
          '';
          locations."~ \\.(js|css|ttf|woff2?|png|jpe?g|svg)$".extraConfig = ''
            add_header Cache-Control "public, max-age=15778463";
            add_header X-Content-Type-Options nosniff;
            add_header X-Robots-Tag none;
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header Referrer-Policy no-referrer;
            access_log off;
          '';
          extraConfig = ''
            try_files $uri /index.php;
          '';
        }
        cfg.nginx
      ];
    };
  };
}
