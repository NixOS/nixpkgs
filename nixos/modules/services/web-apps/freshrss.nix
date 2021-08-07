{ config, lib, pkgs, ... }:

let
  cfg = config.services.freshrss;

  poolName = "freshrss";
in
{
  meta.maintainers = with lib.maintainers; [ etu ];

  options.services.freshrss = {
    enable = lib.mkEnableOption "FreshRSS feed reader";

    virtualHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "freshrss";
      description = ''
        Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
      '';
    };

    pool = lib.mkOption {
      type = lib.types.str;
      default = poolName;
      description = ''
        Name of the phpfpm pool to use and setup. If not specified, a pool will be created
        with default values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Set up a Nginx virtual host.
    services.nginx = lib.mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts.${cfg.virtualHost} = {
        root = "/var/lib/freshrss/p";

        locations."~ \.php$".extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';

        locations."/" = {
          tryFiles = "$uri $uri/ index.php";
          index = "index.php index.html index.htm";
        };
      };
    };

    # Set up phpfpm pool
    services.phpfpm.pools = lib.mkIf (cfg.pool == poolName) {
      ${poolName} = {
        user = "freshrss";
        settings = {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };

    users.users.freshrss = {
      description = "FreshRSS service user";
      isSystemUser = true;
      group = "freshrss";
    };
    users.groups.freshrss = {};

    systemd.services.freshrss-config = {
      description = "Set up the state directory for FreshRSS before use";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "freshrss";
        Group = "freshrss";
        StateDirectory = "freshrss";
        WorkingDirectory = "/var/lib/freshrss";
      };
      script = ''
        # Delete all but the "data" folder
        ls | grep -v data | while read line; do rm -rf $line; done || true

        # Copy all needed source files
        cp -vr $(find ${pkgs.freshrss} -maxdepth 1 -mindepth 1 | grep -e '/cli' -e '/config' -e '/index' -e '/constants.php' -e '/app' -e '/extensions' -e '/p' -e '/lib') .

        # Copy the user data template directory
        cp -vr ${pkgs.freshrss}/data .

        # Remove do-install.txt if we're already set up
        if test -e data/config.php; then
          rm data/do-install.txt
        fi
      '';
    };

    systemd.services.freshrss-updater = {
      description = "FreshRSS feed updater";
      after = [ "freshrss-config.service" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "*:0/5";

      serviceConfig = {
        Type = "oneshot";
        User = "freshrss";
        Group = "freshrss";
        StateDirectory = "freshrss";
        WorkingDirectory = "/var/lib/freshrss";
        ExecStart = "${pkgs.php}/bin/php app/actualize_script.php";
      };
    };
  };
}
