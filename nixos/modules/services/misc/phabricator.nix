{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.phabricator;
in {
  options = {
    services.phabricator = {
      enable = mkEnableOption "phabricator";

      serverName = mkOption {
        type = types.str;
        example = "phabricator.example.com";
        description = "Server name for phabricator without URI scheme.";
      };

      forceSSL = mkOption {
        type = types.bool;
        default = true;
        description = "Enables TLS on the nginx vhost and redirects to it.";
      };

      baseURI = mkOption {
        type = types.str;
        example = "https://phabricator.example.com";
        description = "Base URI for phabricator.";
      };
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

    users.extraUsers = {
      phabricator = {
        group = "phabricator";
        uid = config.ids.uids.phabricator;
      };
    };

    users.extraGroups = {
      phabricator = {
        gid = config.ids.gids.phabricator;
      };
    };

    services = {
      nginx = {
        enable = true;
        virtualHosts = {
          ${cfg.serverName} = {
            root = "${pkgs.phabricator}/phabricator/webroot";
            forceSSL = cfg.forceSSL;
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
      phpfpm.pools.phabricator = {
        listen = "localhost:9000";
        extraConfig = ''
          user = phabricator
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
      postfix.enable = mkDefault true;
    };

    systemd.services = {
      phabricator = let 
        baseURI = "http${optionalString cfg.forceSSL "s"}://${cfg.serverName}";
      in {
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
            chown -R phabricator /var/lib/phabricator
          fi
          ${pkgs.phabricator}/phabricator/bin/storage upgrade --force  # otherwise needs nginx disabled
          ${pkgs.phabricator}/phabricator/bin/config set phabricator.base-uri '${baseURI}'
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
          php git openssh
        ];
        script = ''
          ${pkgs.phabricator}/phabricator/bin/phd start
        '';

        serviceConfig = {
          Type = "oneshot";
          ExecStop = ''${pkgs.phabricator}/phabricator/bin/phd stop'';
          RemainAfterExit = "yes";
          User = "phabricator";
        };
      };
    };
  };
}
