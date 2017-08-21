{ config, lib, pkgs, services, ... }:
with lib;
let
  cfg = config.services.piwik;

  user = "piwik";
  dataDir = "/var/lib/${user}";

  pool = user;
  # it's not possible to use /run/phpfpm/${pool}.sock because /run/phpfpm/ is root:root 0770,
  # and therefore is not accessible by the web server.
  phpSocket = "/run/phpfpm-${pool}.sock";
  phpExecutionUnit = "phpfpm-${pool}";
  databaseService = "mysql.service";

in {
  options = {
    services.piwik = {
      # NixOS PR for database setup: https://github.com/NixOS/nixpkgs/pull/6963
      # piwik issue for automatic piwik setup: https://github.com/piwik/piwik/issues/10257
      # TODO: find a nice way to do this when more NixOS MySQL and / or piwik automatic setup stuff is implemented.
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable piwik web analytics with php-fpm backend.
        '';
      };

      webServerUser = mkOption {
        type = types.str;
        example = "nginx";
        description = ''
          Name of the owner of the ${phpSocket} fastcgi socket for piwik.
          If you want to use another webserver than nginx, you need to set this to that server's user
          and pass fastcgi requests to `index.php` and `piwik.php` to this socket.
        '';
      };

      phpfpmProcessManagerConfig = mkOption {
        type = types.str;
        default = ''
          ; default phpfpm process manager settings
          pm = dynamic
          pm.max_children = 75
          pm.start_servers = 10
          pm.min_spare_servers = 5
          pm.max_spare_servers = 20
          pm.max_requests = 500

          ; log worker's stdout, but this has a performance hit
          catch_workers_output = yes
        '';
        description = ''
          Settings for phpfpm's process manager. You might need to change this depending on the load for piwik.
        '';
      };

      nginx = mkOption {
        # TODO: for maximum flexibility, it would be nice to use nginx's vhost_options module
        #       but this only makes sense if we can somehow specify defaults suitable for piwik.
        #       But users can always copy the piwik nginx config to their configuration.nix and customize it.
        type = types.nullOr (types.submodule {
          options = {
            virtualHost = mkOption {
              type = types.str;
              default = "piwik.${config.networking.hostName}";
              example = "piwik.$\{config.networking.hostName\}";
              description = ''
                  Name of the nginx virtualhost to use and set up.
              '';
            };
            enableSSL = mkOption {
              type = types.bool;
              default = true;
              description = "Whether to enable https.";
            };
            forceSSL = mkOption {
              type = types.bool;
              default = true;
              description = "Whether to always redirect to https.";
            };
            enableACME = mkOption {
              type = types.bool;
              default = true;
              description = "Whether to ask Let's Encrypt to sign a certificate for this vhost.";
            };
          };
        });
        default = null;
        example = { virtualHost = "stats.$\{config.networking.hostName\}"; };
        description = ''
            The options to use to configure an nginx virtualHost.
            If null (the default), no nginx virtualHost will be configured.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers.${user} = {
      isSystemUser = true;
      createHome = true;
      home = dataDir;
      group  = user;
    };
    users.extraGroups.${user} = {};

    systemd.services.piwik_setup_update = {
      # everything needs to set up and up to date before piwik php files are executed
      requiredBy = [ "${phpExecutionUnit}.service" ];
      before = [ "${phpExecutionUnit}.service" ];
      # the update part of the script can only work if the database is already up and running
      requires = [ databaseService ];
      after = [ databaseService ];
      path = [ pkgs.piwik ];
      serviceConfig = {
        Type = "oneshot";
        User = user;
        # hide especially config.ini.php from other
        UMask = "0007";
        Environment = "PIWIK_USER_PATH=${dataDir}";
        # chown + chmod in preStart needs root
        PermissionsStartOnly = true;
      };
      # correct ownership and permissions in case they're not correct anymore,
      # e.g. after restoring from backup or moving from another system.
      # Note that ${dataDir}/config/config.ini.php might contain the MySQL password.
      preStart = ''
        chown -R ${user}:${user} ${dataDir}
        chmod -R ug+rwX,o-rwx ${dataDir}
        '';
      script = ''
            # Use User-Private Group scheme to protect piwik data, but allow administration / backup via piwik group
            # Copy config folder
            chmod g+s "${dataDir}"
            cp -r "${pkgs.piwik}/config" "${dataDir}/"
            chmod -R u+rwX,g+rwX,o-rwx "${dataDir}"

            # check whether user setup has already been done
            if test -f "${dataDir}/config/config.ini.php"; then
              # then execute possibly pending database upgrade
              piwik-console core:update --yes
            fi
      '';
    };

    systemd.services.${phpExecutionUnit} = {
      # stop phpfpm on package upgrade, do database upgrade via piwik_setup_update, and then restart
      restartTriggers = [ pkgs.piwik ];
      # stop config.ini.php from getting written with read permission for others
      serviceConfig.UMask = "0007";
    };

    services.phpfpm.poolConfigs = {
      ${pool} = ''
        listen = "${phpSocket}"
        listen.owner = ${cfg.webServerUser}
        listen.group = root
        listen.mode = 0600
        user = ${user}
        env[PIWIK_USER_PATH] = ${dataDir}
        ${cfg.phpfpmProcessManagerConfig}
      '';
    };


    services.nginx.virtualHosts = mkIf (cfg.nginx != null) {
      # References:
      # https://fralef.me/piwik-hardening-with-nginx-and-php-fpm.html
      # https://github.com/perusio/piwik-nginx
      ${cfg.nginx.virtualHost} = {
        root = "${pkgs.piwik}/share";
        enableSSL  = cfg.nginx.enableSSL;
        enableACME = cfg.nginx.enableACME;
        forceSSL   = cfg.nginx.forceSSL;

        locations."/" = {
          index = "index.php";
        };
        # allow index.php for webinterface
        locations."= /index.php".extraConfig = ''
          fastcgi_pass unix:${phpSocket};
        '';
        # allow piwik.php for tracking
        locations."= /piwik.php".extraConfig = ''
          fastcgi_pass unix:${phpSocket};
        '';
        # Any other attempt to access any php files is forbidden
        locations."~* ^.+\.php$".extraConfig = ''
          return 403;
        '';
        # Disallow access to unneeded directories
        # config and tmp are already removed
        locations."~ ^/(?:core|lang|misc)/".extraConfig = ''
          return 403;
        '';
        # Disallow access to several helper files
        locations."~* \.(?:bat|git|ini|sh|txt|tpl|xml|md)$".extraConfig = ''
          return 403;
        '';
        # No crawling of this site for bots that obey robots.txt - no useful information here.
        locations."= /robots.txt".extraConfig = ''
          return 200 "User-agent: *\nDisallow: /\n";
        '';
        # let browsers cache piwik.js
        locations."= /piwik.js".extraConfig = ''
          expires 1M;
        '';
      };
    };
  };

  meta = {
    doc = ./piwik-doc.xml;
    maintainers = with stdenv.lib.maintainers; [ florianjacob ];
  };
}
