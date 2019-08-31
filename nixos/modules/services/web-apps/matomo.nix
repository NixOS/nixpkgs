{ config, lib, pkgs, ... }:
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

      package = mkOption {
        type = types.package;
        description = ''
          Matomo package for the service to use.
          This can be used to point to newer releases from nixos-unstable,
          as they don't get backported if they are not security-relevant.
        '';
        default = pkgs.matomo;
        defaultText = "pkgs.matomo";
      };

      webServerUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "lighttpd";
        description = ''
          Name of the web server user that forwards requests to the ${phpSocket} fastcgi socket for Matomo if the nginx
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
          make sure though that you run <literal>systemctl start matomo-archive-processing.service</literal>
          at least once without errors if you have already collected data before.
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
          Settings for phpfpm's process manager. You might need to change this depending on the load for Matomo.
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
        example = {
          serverAliases = [
            "matomo.$\{config.networking.domain\}"
            "stats.$\{config.networking.domain\}"
          ];
          enableACME = false;
        };
        description = ''
            With this option, you can customize an nginx virtualHost which already has sensible defaults for Matomo.
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
        '';
      script = ''
            # Use User-Private Group scheme to protect Matomo data, but allow administration / backup via 'matomo' group
            # Copy config folder
            chmod g+s "${dataDir}"
            cp -r "${cfg.package}/share/config" "${dataDir}/"
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
        ExecStart = "${cfg.package}/bin/matomo-console core:archive --url=https://${user}.${fqdn}";
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
        listen = phpSocket;
        extraConfig = ''
          listen.owner = ${socketOwner}
          listen.group = root
          listen.mode = 0600
          user = ${user}
          env[PIWIK_USER_PATH] = ${dataDir}
          ${cfg.phpfpmProcessManagerConfig}
        '';
      };
    };


    services.nginx.virtualHosts = mkIf (cfg.nginx != null) {
      # References:
      # https://fralef.me/piwik-hardening-with-nginx-and-php-fpm.html
      # https://github.com/perusio/piwik-nginx
      "${user}.${fqdn}" = mkMerge [ cfg.nginx {
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
          fastcgi_pass unix:${phpSocket};
        '';
        # allow matomo.php for tracking
        locations."= /matomo.php".extraConfig = ''
          fastcgi_pass unix:${phpSocket};
        '';
        # allow piwik.php for tracking (deprecated name)
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
    doc = ./matomo-doc.xml;
    maintainers = with lib.maintainers; [ florianjacob ];
  };
}
