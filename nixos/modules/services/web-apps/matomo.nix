{ config, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.services.matomo;
  fpm = config.services.phpfpm.pools.${pool};

  user = "matomo";
  dataDir = "/var/lib/${user}";
  deprecatedDataDir = "/var/lib/piwik";

  pool = user;
  phpExecutionUnit = "phpfpm-${pool}";
  databaseService = "mysql.service";

in {
  imports = [
    (mkRenamedOptionModule [ "services" "piwik" "enable" ] [ "services" "matomo" "enable" ])
    (mkRenamedOptionModule [ "services" "piwik" "webServerUser" ] [ "services" "matomo" "webServerUser" ])
    (mkRemovedOptionModule [ "services" "piwik" "phpfpmProcessManagerConfig" ] "Use services.phpfpm.pools.<name>.settings")
    (mkRemovedOptionModule [ "services" "matomo" "phpfpmProcessManagerConfig" ] "Use services.phpfpm.pools.<name>.settings")
    (mkRenamedOptionModule [ "services" "piwik" "nginx" ] [ "services" "matomo" "nginx" ])
    (mkRenamedOptionModule [ "services" "matomo" "periodicArchiveProcessingUrl" ] [ "services" "matomo" "hostname" ])
  ];

  options = {
    services.matomo = {
      # NixOS PR for database setup: https://github.com/NixOS/nixpkgs/pull/6963
      # Matomo issue for automatic Matomo setup: https://github.com/matomo-org/matomo/issues/10257
      # TODO: find a nice way to do this when more NixOS MySQL and / or Matomo automatic setup stuff is implemented.
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Matomo web analytics with php-fpm backend.
          Either the nginx option or the webServerUser option is mandatory.
        '';
      };

      package = mkPackageOption pkgs "matomo" { };

      webServerUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "lighttpd";
        description = ''
          Name of the web server user that forwards requests to {option}`services.phpfpm.pools.<name>.socket` the fastcgi socket for Matomo if the nginx
          option is not used. Either this option or the nginx option is mandatory.
          If you want to use another webserver than nginx, you need to set this to that server's user
          and pass fastcgi requests to `index.php`, `matomo.php` and `piwik.php` (legacy name) to this socket.
        '';
      };

      periodicArchiveProcessing = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable periodic archive processing, which generates aggregated reports from the visits.

          This means that you can safely disable browser triggers for Matomo archiving,
          and safely enable to delete old visitor logs.
          Before deleting visitor logs,
          make sure though that you run `systemctl start matomo-archive-processing.service`
          at least once without errors if you have already collected data before.
        '';
      };

      hostname = mkOption {
        type = types.str;
        default = "${user}.${config.networking.fqdnOrHostName}";
        defaultText = literalExpression ''
          "${user}.''${config.${options.networking.fqdnOrHostName}}"
        '';
        example = "matomo.yourdomain.org";
        description = ''
          URL of the host, without https prefix. You may want to change it if you
          run Matomo on a different URL than matomo.yourdomain.
        '';
      };

      nginx = mkOption {
        type = types.nullOr (types.submodule (
          recursiveUpdate
            (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
            {
              # enable encryption by default,
              # as sensitive login and Matomo data should not be transmitted in clear text.
              options.forceSSL.default = true;
              options.enableACME.default = true;
            }
        )
        );
        default = null;
        example = literalExpression ''
          {
            serverAliases = [
              "matomo.''${config.networking.domain}"
              "stats.''${config.networking.domain}"
            ];
            enableACME = false;
          }
        '';
        description = ''
            With this option, you can customize an nginx virtualHost which already has sensible defaults for Matomo.
            Either this option or the webServerUser option is mandatory.
            Set this to {} to just enable the virtualHost if you don't need any customization.
            If enabled, then by default, the {option}`serverName` is
            `''${user}.''${config.networking.hostName}.''${config.networking.domain}`,
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
        message = "Either services.matomo.nginx or services.matomo.webServerUser is mandatory";
    }];

    users.users.${user} = {
      isSystemUser = true;
      createHome = true;
      home = dataDir;
      group  = user;
    };
    users.groups.${user} = {};

    systemd.services.matomo-setup-update = {
      # everything needs to set up and up to date before Matomo php files are executed
      requiredBy = [ "${phpExecutionUnit}.service" ];
      before = [ "${phpExecutionUnit}.service" ];
      # the update part of the script can only work if the database is already up and running
      requires = [ databaseService ];
      after = [ databaseService ];
      path = [ cfg.package ];
      environment.PIWIK_USER_PATH = dataDir;
      serviceConfig = {
        Type = "oneshot";
        User = user;
        # hide especially config.ini.php from other
        UMask = "0007";
        # TODO: might get renamed to MATOMO_USER_PATH in future versions
        # chown + chmod in preStart needs root
        PermissionsStartOnly = true;
      };

      # correct ownership and permissions in case they're not correct anymore,
      # e.g. after restoring from backup or moving from another system.
      # Note that ${dataDir}/config/config.ini.php might contain the MySQL password.
      preStart = ''
        # migrate data from piwik to Matomo folder
        if [ -d ${deprecatedDataDir} ]; then
          echo "Migrating from ${deprecatedDataDir} to ${dataDir}"
          mv -T ${deprecatedDataDir} ${dataDir}
        fi
        chown -R ${user}:${user} ${dataDir}
        chmod -R ug+rwX,o-rwx ${dataDir}

        if [ -e ${dataDir}/current-package ]; then
          CURRENT_PACKAGE=$(readlink ${dataDir}/current-package)
          NEW_PACKAGE=${cfg.package}
          if [ "$CURRENT_PACKAGE" != "$NEW_PACKAGE" ]; then
            # keeping tmp around between upgrades seems to bork stuff, so delete it
            rm -rf ${dataDir}/tmp
          fi
        elif [ -e ${dataDir}/tmp ]; then
          # upgrade from 4.4.1
          rm -rf ${dataDir}/tmp
        fi
        ln -sfT ${cfg.package} ${dataDir}/current-package
        '';
      script = ''
            # Use User-Private Group scheme to protect Matomo data, but allow administration / backup via 'matomo' group
            # Copy config folder
            chmod g+s "${dataDir}"
            cp -r "${cfg.package}/share/config" "${dataDir}/"
            mkdir -p "${dataDir}/misc"
            chmod -R u+rwX,g+rwX,o-rwx "${dataDir}"

            # check whether user setup has already been done
            if test -f "${dataDir}/config/config.ini.php"; then
              # then execute possibly pending database upgrade
              matomo-console core:update --yes
            fi
      '';
    };

    # If this is run regularly via the timer,
    # 'Browser trigger archiving' can be disabled in Matomo UI > Settings > General Settings.
    systemd.services.matomo-archive-processing = {
      description = "Archive Matomo reports";
      # the archiving can only work if the database is already up and running
      requires = [ databaseService ];
      after = [ databaseService ];

      # TODO: might get renamed to MATOMO_USER_PATH in future versions
      environment.PIWIK_USER_PATH = dataDir;
      serviceConfig = {
        Type = "oneshot";
        User = user;
        UMask = "0007";
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ExecStart = "${cfg.package}/bin/matomo-console core:archive --url=https://${cfg.hostname}";
      };
    };

    systemd.timers.matomo-archive-processing = mkIf cfg.periodicArchiveProcessing {
      description = "Automatically archive Matomo reports every hour";

      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = "yes";
        AccuracySec = "10m";
      };
    };

    systemd.services.${phpExecutionUnit} = {
      # stop phpfpm on package upgrade, do database upgrade via matomo-setup-update, and then restart
      restartTriggers = [ cfg.package ];
      # stop config.ini.php from getting written with read permission for others
      serviceConfig.UMask = "0007";
    };

    services.phpfpm.pools = let
      # workaround for when both are null and need to generate a string,
      # which is illegal, but as assertions apparently are being triggered *after* config generation,
      # we have to avoid already throwing errors at this previous stage.
      socketOwner = if (cfg.nginx != null) then config.services.nginx.user
      else if (cfg.webServerUser != null) then cfg.webServerUser else "";
    in {
      ${pool} = {
        inherit user;
        phpOptions = ''
          error_log = 'stderr'
          log_errors = on
        '';
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = socketOwner;
          "listen.group" = "root";
          "listen.mode" = "0660";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = true;
        };
        phpEnv.PIWIK_USER_PATH = dataDir;
      };
    };


    services.nginx.virtualHosts = mkIf (cfg.nginx != null) {
      # References:
      # https://fralef.me/piwik-hardening-with-nginx-and-php-fpm.html
      # https://github.com/perusio/piwik-nginx
      "${cfg.hostname}" = mkMerge [ cfg.nginx {
        # don't allow to override the root easily, as it will almost certainly break Matomo.
        # disadvantage: not shown as default in docs.
        root = mkForce "${cfg.package}/share";

        # define locations here instead of as the submodule option's default
        # so that they can easily be extended with additional locations if required
        # without needing to redefine the Matomo ones.
        # disadvantage: not shown as default in docs.
        locations."/" = {
          index = "index.php";
        };
        # allow index.php for webinterface
        locations."= /index.php".extraConfig = ''
          fastcgi_pass unix:${fpm.socket};
        '';
        # allow matomo.php for tracking
        locations."= /matomo.php".extraConfig = ''
          fastcgi_pass unix:${fpm.socket};
        '';
        # allow piwik.php for tracking (deprecated name)
        locations."= /piwik.php".extraConfig = ''
          fastcgi_pass unix:${fpm.socket};
        '';
        # Any other attempt to access any php files is forbidden
        locations."~* ^.+\\.php$".extraConfig = ''
          return 403;
        '';
        # Disallow access to unneeded directories
        # config and tmp are already removed
        locations."~ ^/(?:core|lang|misc)/".extraConfig = ''
          return 403;
        '';
        # Disallow access to several helper files
        locations."~* \\.(?:bat|git|ini|sh|txt|tpl|xml|md)$".extraConfig = ''
          return 403;
        '';
        # No crawling of this site for bots that obey robots.txt - no useful information here.
        locations."= /robots.txt".extraConfig = ''
          return 200 "User-agent: *\nDisallow: /\n";
        '';
        # let browsers cache matomo.js
        locations."= /matomo.js".extraConfig = ''
          expires 1M;
        '';
        # let browsers cache piwik.js (deprecated name)
        locations."= /piwik.js".extraConfig = ''
          expires 1M;
        '';
      }];
    };
  };

  meta = {
    doc = ./matomo.md;
    maintainers = with lib.maintainers; [ florianjacob ];
  };
}
