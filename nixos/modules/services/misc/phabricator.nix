{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.phabricator;
in {
  options = {
    services.phabricator = {
      enable = mkEnableOption "phabricator";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [];

    # Redis is required for the sidekiq queue runner.
    # services.redis.enable = mkDefault true;
    # We use postgres as the main data store.
    # services.postgresql.enable = mkDefault true;
    # Use postfix to send out mails.
    # services.postfix.enable = mkDefault true;

    # users.extraUsers = [
    #   { name = cfg.user;
    #     group = cfg.group;
    #     home = "${cfg.statePath}/home";
    #     shell = "${pkgs.bash}/bin/bash";
    #     uid = config.ids.uids.gitlab;
    #   }
    # ];

    # users.extraGroups = [
    #   { name = cfg.group;
    #     gid = config.ids.gids.gitlab;
    #   }
    # ];

    services = {
      nginx = {
        enable = true;
        virtualHosts = {
          "phabricator.localhost" = {
            root = "${pkgs.phabricator}/phabricator/webroot";
            locations = {
              "/" = {
                index = "index.php";
                extraConfig = ''
                  rewrite ^/(.*)$ /index.php?__path__=/$1 last;
                '';
              };
              "= /favicon.ico" = {
                tryFiles = "$uri =204";
              };
              "/index.php" = {
                extraConfig = ''
                  fastcgi_pass   localhost:9000;
                  fastcgi_index   index.php;
                '';
              };
            };
          };
        };
      };
      phpfpm.pools.www = {
        listen = "localhost:9000";
        extraConfig = ''
          user = nobody
          pm = dynamic
          pm.max_children = 75
          pm.start_servers = 10
          pm.min_spare_servers = 5
          pm.max_spare_servers = 20
          pm.max_requests = 500
          php_admin_value[post_max_size] = 32M

        '';
      };
      mysql = {
        enable = true;
        package = pkgs.mysql;
      };
      postfix.enable = true;
    };

    systemd.services = {
      phabricator = {
        after = [ "network.target" "mysql.service" "phpfpm.service" ];
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [
          php
        ];
        script = ''
          mkdir -p /run/phabricator
          ln -sf /var/lib/phabricator/conf /run/phabricator/conf
          mkdir -p /var/lib/phabricator/repo
          if [[ ! -d /var/lib/phabricator/conf ]]; then
            mkdir -p /var/lib/phabricator/conf
            cp -r ${pkgs.phabricator}/phabricator/conf.dist/* /var/lib/phabricator/conf
            chown -R nobody /var/lib/phabricator
          fi
          ${pkgs.phabricator}/phabricator/bin/storage upgrade --force  # otherwise needs nginx disabled
          ${pkgs.phabricator}/phabricator/bin/config set phabricator.base-uri 'http://phabricator.localhost/'
          ${pkgs.phabricator}/phabricator/bin/config set environment.append-paths \
            '[ "${pkgs.which}/bin", "${pkgs.diffutils}/bin", "${pkgs.pythonPackages.pygments}/bin",
               "${pkgs.git}/bin" ]'
          ${pkgs.phabricator}/phabricator/bin/config set pygments.enabled true
          ${pkgs.phabricator}/phabricator/bin/config set phabricator.timezone 'Europe/Berlin'
          ${pkgs.phabricator}/phabricator/bin/config set repository.default-local-path /var/lib/phabricator/repo
        '';

        serviceConfig = {
          Type = "oneshot";
        };
      };

      phd = {
        after = [ "network.target" "mysql.service" "phpfpm.service" ];
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [
          php git
        ];
        script = ''
          ${pkgs.phabricator}/phabricator/bin/phd start
        '';

        serviceConfig = {
          Type = "oneshot";
          ExecStop = ''${pkgs.phabricator}/phabricator/bin/phd stop'';
          RemainAfterExit = "yes";
        };
      };
    };
  };
}
