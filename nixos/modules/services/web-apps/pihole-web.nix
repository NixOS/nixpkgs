{
  pkgs,
  lib,
  config,
  ...
}:

with { inherit (lib) mkOption types; };

let
  cfg = config.services.pihole-web;
  ftlCfg = config.services.pihole-ftl;
in
{
  options.services.pihole-web = {
    enable = lib.mkEnableOption "Pi-hole dashboard";
    hostName = mkOption {
      type = types.str;
      description = "Domain name for the website.";
      default = "pi.hole";
    };
    package = lib.mkPackageOption pkgs "pihole-web" { };
    dnsServers = mkOption {
      type = types.str;
      description = ''
        DNS providers list.
        The default value is extracted from [the pihole installation
        script](https://github.com/pi-hole/pi-hole/blob/6a45c6a8e027e1ac30d4556a88f31684bc80ccf1/advanced/Scripts/piholeLogFlush.sh#L45-L53).
      '';
      default = ''
        Google (ECS);8.8.8.8;8.8.4.4;2001:4860:4860:0:0:0:0:8888;2001:4860:4860:0:0:0:0:8844
        OpenDNS (ECS, DNSSEC);208.67.222.222;208.67.220.220;2620:119:35::35;2620:119:53::53
        Level3;4.2.2.1;4.2.2.2;;
        Comodo;8.26.56.26;8.20.247.20;;
        DNS.WATCH;84.200.69.80;84.200.70.40;2001:1608:10:25:0:0:1c04:b12f;2001:1608:10:25:0:0:9249:d69b
        Quad9 (filtered, DNSSEC);9.9.9.9;149.112.112.112;2620:fe::fe;2620:fe::9
        Quad9 (unfiltered, no DNSSEC);9.9.9.10;149.112.112.10;2620:fe::10;2620:fe::fe:10
        Quad9 (filtered + ECS);9.9.9.11;149.112.112.11;2620:fe::11;2620:fe::fe:11
        Cloudflare;1.1.1.1;1.0.0.1;2606:4700:4700::1111;2606:4700:4700::1001
      '';
    };
    theme = mkOption {
      type = types.enum [
        "default-light"
        "default-dark"
        "default-darker"
        "default-auto"
        "lcars"
      ];
      description = "Website theme";
      default = "default-light";
      example = "default-dark";
    };
    temperatureUnit = mkOption {
      type = types.enum [
        "C"
        "F"
      ];
      description = "Temperature display unit";
      default = "C";
      example = "F";
    };
    enablePolkitRule = mkOption {
      type = types.bool;
      description = ''
        Enable a Polkit rule which allows users to restart the pihole-FTL daemon
        from the Update Gravity webpage.
      '';
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.phpfpm.pools.pihole = {
      user = ftlCfg.user;
      group = ftlCfg.group;
      phpPackage = pkgs.php;
      settings = lib.mapAttrs (name: lib.mkDefault) {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
        "pm" = "ondemand";
        "pm.max_children" = 5;
      };
    };

    services.nginx.virtualHosts.${cfg.hostName} = {
      root = "${cfg.package}/share";
      locations = {
        "/".index = "index.php";
        "~ \\.php$".extraConfig = ''
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_param SERVER_NAME $host;
          fastcgi_pass unix:${config.services.phpfpm.pools.pihole.socket};
          fastcgi_intercept_errors on;
          fastcgi_request_buffering off;
        '';
        "= /favicon.ico".extraConfig = "access_log off; log_not_found off;";
      };

      # Some inline styles and scripts require the unsafe-inline CSP
      # See https://github.com/pi-hole/web/pull/1377
      extraConfig = ''
        add_header X-Pi-hole "The Pi-hole Web interface is working!";
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "0";
        add_header X-Content-Type-Options "nosniff";
        add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';";
        add_header X-Permitted-Cross-Domain-Policies "none";
        add_header Referrer-Policy "same-origin";
      '';
    };

    # The Update Gravity page requires writing to pihole's state directory
    systemd.services.phpfpm-pihole.serviceConfig = {
      ReadWritePaths = [
        ftlCfg.stateDirectory
        ftlCfg.logDirectory
      ];
    };

    environment.etc."pihole/dns-servers.conf" = {
      user = ftlCfg.user;
      group = ftlCfg.group;
      text = cfg.dnsServers;
    };

    # The Update Gravity page needs to restart pihole-ftl
    security.polkit.extraConfig = lib.mkIf cfg.enablePolkitRule ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "pihole-ftl.service" &&
              action.lookup("verb") == "restart" &&
              subject.user == "${ftlCfg.user}") {
              return polkit.Result.YES;
          }
      });
    '';
  };

  meta = {
    doc = ./pihole-web.md;
    maintainers = with lib.maintainers; [ williamvds ];
  };
}
