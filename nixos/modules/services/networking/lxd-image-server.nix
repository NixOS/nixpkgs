{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.lxd-image-server;
  format = pkgs.formats.toml {};

  location = "/var/www/simplestreams";
in
{
  options = {
    services.lxd-image-server = {
      enable = mkEnableOption "lxd-image-server";

      group = mkOption {
        type = types.str;
        description = lib.mdDoc "Group assigned to the user and the webroot directory.";
        default = "nginx";
        example = "www-data";
      };

      settings = mkOption {
        type = format.type;
        description = lib.mdDoc ''
          Configuration for lxd-image-server.

          Example see <https://github.com/Avature/lxd-image-server/blob/master/config.toml>.
        '';
        default = {};
      };

      nginx = {
        enable = mkEnableOption "nginx";
        domain = mkOption {
          type = types.str;
          description = lib.mdDoc "Domain to use for nginx virtual host.";
          example = "images.example.org";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      users.users.lxd-image-server = {
        isSystemUser = true;
        group = cfg.group;
      };
      users.groups.${cfg.group} = {};

      environment.etc."lxd-image-server/config.toml".source = format.generate "config.toml" cfg.settings;

      services.logrotate.settings.lxd-image-server = {
        files = "/var/log/lxd-image-server/lxd-image-server.log";
        frequency = "daily";
        rotate = 21;
        create = "755 lxd-image-server ${cfg.group}";
        compress = true;
        delaycompress = true;
        copytruncate = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/www/simplestreams 0755 lxd-image-server ${cfg.group}"
      ];

      systemd.services.lxd-image-server = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        description = "LXD Image Server";

        script = ''
          ${pkgs.lxd-image-server}/bin/lxd-image-server init
          ${pkgs.lxd-image-server}/bin/lxd-image-server watch
        '';

        serviceConfig = {
          User = "lxd-image-server";
          Group = cfg.group;
          DynamicUser = true;
          LogsDirectory = "lxd-image-server";
          RuntimeDirectory = "lxd-image-server";
          ExecReload = "${pkgs.lxd-image-server}/bin/lxd-image-server reload";
          ReadWritePaths = [ location ];
        };
      };
    })
    # this is seperate so it can be enabled on mirrored hosts
    (mkIf (cfg.nginx.enable) {
      # https://github.com/Avature/lxd-image-server/blob/master/resources/nginx/includes/lxd-image-server.pkg.conf
      services.nginx.virtualHosts = {
        "${cfg.nginx.domain}" = {
          forceSSL = true;
          enableACME = mkDefault true;

          root = location;

          locations = {
            "/streams/v1/" = {
              index = "index.json";
            };

            # Serve json files with content type header application/json
            "~ \.json$" = {
              extraConfig = ''
                add_header Content-Type application/json;
              '';
            };

            "~ \.tar.xz$" = {
              extraConfig = ''
                add_header Content-Type application/octet-stream;
              '';
            };

            "~ \.tar.gz$" = {
              extraConfig = ''
                add_header Content-Type application/octet-stream;
              '';
            };

            # Deny access to document root and the images folder
            "~ ^/(images/)?$" = {
              return = "403";
            };
          };
        };
      };
    })
  ];
}
