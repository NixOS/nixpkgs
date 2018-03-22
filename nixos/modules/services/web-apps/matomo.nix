{ config, lib, pkgs, services, ... }:
with lib;
let
  cfg = config.services.matomo;

  user = "matomo";
  dataDir = "/var/lib/${user}";
  deprecatedDataDir = "/var/lib/piwik";

  pool = user;
  # it's not possible to use /run/phpfpm/${pool}.sock because /run/phpfpm/ is root:root 0770,
  # and therefore is not accessible by the web server.
  phpSocket = "/run/phpfpm-${pool}.sock";
  phpExecutionUnit = "phpfpm-${pool}";
  databaseService = "mysql.service";

  fqdn =
    let
      join = hostName: domain: hostName + optionalString (domain != null) ".${domain}";
     in join config.networking.hostName config.networking.domain;

in {
  options = {
    services.matomo = {
      # NixOS PR for database setup: https://github.com/NixOS/nixpkgs/pull/6963
      # matomo issue for automatic matomo setup: https://github.com/matomo-org/matomo/issues/10257
      # TODO: find a nice way to do this when more NixOS MySQL and / or matomo automatic setup stuff is implemented.
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable matomo web analytics with php-fpm backend.
          Either the nginx option or the webServerUser option is mandatory.
        '';
      };

      webServerUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "lighttpd";
        # TODO: piwik.php might get renamed to matomo.php in future releases
        description = ''
          Name of the web server user that forwards requests to the ${phpSocket} fastcgi socket for matomo if the nginx
          option is not used. Either this option or the nginx option is mandatory.
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
          Settings for phpfpm's process manager. You might need to change this depending on the load for matomo.
        '';
      };

      nginx = mkOption {
        type = types.nullOr (types.submodule (
          recursiveUpdate
            (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
            {
              # enable encryption by default,
              # as sensitive login and matomo data should not be transmitted in clear text.
              options.forceSSL.default = true;
              options.enableACME.default = true;
            }
        )
        );
        default = null;
        example = {
          serverAliases = [
            "matomo.$\{config.networking.domain\}"
            "stats.$\{config.networking.domain\}"
          ];
          enableACME = false;
        };
        description = ''
            With this option, you can customize an nginx virtualHost which already has sensible defaults for matomo.
            Either this option or the webServerUser option is mandatory.
            Set this to {} to just enable the virtualHost if you don't need any customization.
            If enabled, then by default, the <option>serverName</option> is
            <literal>${user}.$\{config.networking.hostName\}.$\{config.networking.domain\}</literal>,
            SSL is active, and certificates are acquired via ACME.
            If this is set to null (the default), no nginx virtualHost will be configured.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = mkIf (cfg.nginx != null && cfg.webServerUser != null) [
      "If services.matomo.nginx is set, services.matomo.nginx.webServerUser is ignored and should be removed."
    ];

    assertions = [ {
        assertion = cfg.nginx != null || cfg.webServerUser != null;
        message = "Either services.matomo.nginx or services.matomo.nginx.webServerUser is mandatory";
    }];

    users.extraUsers.${user} = {
      isSystemUser = true;
      createHome = true;
      home = dataDir;
      group  = user;
    };
    users.extraGroups.${user} = {};

    systemd.services.matomo_setup_update = {
      # everything needs to set up and up to date before matomo php files are executed
      requiredBy = [ "${phpExecutionUnit}.service" ];
      before = [ "${phpExecutionUnit}.service" ];
      # the update part of the script can only work if the database is already up and running
      requires = [ databaseService ];
      after = [ databaseService ];
      path = [ pkgs.matomo ];
      serviceConfig = {
        Type = "oneshot";
        User = user;
        # hide especially config.ini.php from other
        UMask = "0007";
        # TODO: might get renamed to MATOMO_USER_PATH in future versions
        Environment = "PIWIK_USER_PATH=${dataDir}";
        # chown + chmod in preStart needs root
        PermissionsStartOnly = true;
      };
      # correct ownership and permissions in case they're not correct anymore,
      # e.g. after restoring from backup or moving from another system.
      # Note that ${dataDir}/config/config.ini.php might contain the MySQL password.
      preStart = ''
        # migrate data from piwik to matomo folder
        if [ -d ${deprecatedDataDir} ]; then
          echo "Migrating from ${deprecatedDataDir} to ${dataDir}"
          mv -T ${deprecatedDataDir} ${dataDir}
        fi
        chown -R ${user}:${user} ${dataDir}
        chmod -R ug+rwX,o-rwx ${dataDir}
        '';
      script = ''
            # Use User-Private Group scheme to protect matomo data, but allow administration / backup via matomo group
            # Copy config folder
            chmod g+s "${dataDir}"
            cp -r "${pkgs.matomo}/config" "${dataDir}/"
            chmod -R u+rwX,g+rwX,o-rwx "${dataDir}"

            # check whether user setup has already been done
            if test -f "${dataDir}/config/config.ini.php"; then
              # then execute possibly pending database upgrade
              matomo-console core:update --yes
            fi
      '';
    };

    systemd.services.${phpExecutionUnit} = {
      # stop phpfpm on package upgrade, do database upgrade via matomo_setup_update, and then restart
      restartTriggers = [ pkgs.matomo ];
      # stop config.ini.php from getting written with read permission for others
      serviceConfig.UMask = "0007";
    };

    services.phpfpm.poolConfigs = let
      # workaround for when both are null and need to generate a string,
      # which is illegal, but as assertions apparently are being triggered *after* config generation,
      # we have to avoid already throwing errors at this previous stage.
      socketOwner = if (cfg.nginx != null) then config.services.nginx.user
      else if (cfg.webServerUser != null) then cfg.webServerUser else "";
    in {
      ${pool} = ''
        listen = "${phpSocket}"
        listen.owner = ${socketOwner}
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
      "${user}.${fqdn}" = mkMerge [ cfg.nginx {
        # don't allow to override the root easily, as it will almost certainly break matomo.
        # disadvantage: not shown as default in docs.
        root = mkForce "${pkgs.matomo}/share";

        # define locations here instead of as the submodule option's default
        # so that they can easily be extended with additional locations if required
        # without needing to redefine the matomo ones.
        # disadvantage: not shown as default in docs.
        locations."/" = {
          index = "index.php";
        };
        # allow index.php for webinterface
        locations."= /index.php".extraConfig = ''
          fastcgi_pass unix:${phpSocket};
        '';
        # TODO: might get renamed to matomo.php in future versions
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
        # TODO: might get renamed to matomo.js in future versions
        # let browsers cache piwik.js
        locations."= /piwik.js".extraConfig = ''
          expires 1M;
        '';
      }];
    };
  };

  meta = {
    doc = ./matomo-doc.xml;
    maintainers = with stdenv.lib.maintainers; [ florianjacob ];
  };
}
