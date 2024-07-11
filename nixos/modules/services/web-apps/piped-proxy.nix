{
  lib,
  config,
  pkgs,
  ...
}:

let
  this = config.services.piped.proxy;
  https =
    domain: if lib.hasSuffix ".localhost" domain then "http://${domain}" else "https://${domain}";
in

{
  options.services.piped.proxy = {
    enable = lib.mkEnableOption "Piped Proxy";

    package = lib.mkPackageOption pkgs "piped-proxy" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = if this.nginx.enable then "127.0.0.1" else "0.0.0.0";
      defaultText = lib.literalExpression ''if config.services.piped.proxy.nginx.enable then "127.0.0.1" else "0.0.0.0"'';
      description = ''
        The IP address Piped Proxy should bind to.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      example = 8001;
      default = 28784;
      description = ''
        The port Piped Proxy should listen on.

        To allow access from outside,
        you can use either {option}`services.piped.proxy.nginx`
        or add `config.services.piped.proxy.port` to {option}`networking.firewall.allowedTCPPorts`.
      '';
    };

    externalUrl = lib.mkOption {
      type = lib.types.str;
      example = "https://pipedproxy.example.com";
      default = https this.nginx.domain;
      defaultText = "The {option}`nginx.domain`";
      description = ''
        The external URL of Piped Proxy.
      '';
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to configure nginx as a reverse proxy for Piped Proxy.
        '';
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "pipedproxy.localhost";
        description = ''
          The domain Piped Proxy is reachable on.
        '';
      };
    };
  };

  config = lib.mkIf this.enable {
    services.piped.backend.settings = {
      PROXY_PART = this.externalUrl;
    };

    systemd.services.piped-proxy = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "piped-proxy";
        Group = "piped-proxy";
        DynamicUser = true;
      };
      environment = {
        BIND = "${this.address}:${toString this.port}";
      };
      script = ''
        ${this.package}/bin/piped-proxy
      '';
    };

    services.nginx = lib.mkIf this.nginx.enable {
      enable = true;
      virtualHosts.${this.nginx.domain} =
        let
          # Taken from https://github.com/TeamPiped/Piped-Docker/blob/main/template/ytproxy.conf
          ytproxy = ''
            proxy_buffering on;
            proxy_buffers 1024 16k;
            proxy_set_header X-Forwarded-For "";
            proxy_set_header CF-Connecting-IP "";
            proxy_hide_header "alt-svc";
            sendfile on;
            sendfile_max_chunk 512k;
            tcp_nopush on;
            aio threads=default;
            aio_write on;
            directio 16m;
            proxy_hide_header Cache-Control;
            proxy_hide_header etag;
            proxy_http_version 1.1;
            proxy_set_header Connection keep-alive;
            proxy_max_temp_file_size 32m;
            access_log off;
          '';
        in
        {
          locations."/" = {
            proxyPass = "http://${this.address}:${toString this.port}";
            extraConfig = ''
              ${ytproxy}
              add_header Cache-Control "public, max-age=604800";
            '';
          };
          locations."~ (/videoplayback|/api/v4/|/api/manifest/)" = {
            proxyPass = "http://${this.address}:${toString this.port}";
            extraConfig = ''
              ${ytproxy}
              add_header Cache-Control private always;
            '';
          };
        };
    };
  };

  meta.maintainers = with lib.maintainers; [
    defelo
    atemu
  ];
}
