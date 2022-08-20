srv:
{ configIniOfService
, srvsrht ? "${srv}srht" # Because "buildsrht" does not follow that pattern (missing an "s").
, iniKey ? "${srv}.sr.ht"
, webhooks ? false
, extraTimers ? {}
, mainService ? {}
, extraServices ? {}
, extraConfig ? {}
, port
}:
{ config, lib, pkgs, ... }:

with lib;
let
  inherit (config.services) postgresql;
  redis = config.services.redis.servers."sourcehut-${srvsrht}";
  inherit (config.users) users;
  cfg = config.services.sourcehut;
  configIni = configIniOfService srv;
  srvCfg = cfg.${srv};
  baseService = serviceName: { allowStripe ? false }: extraService: let
    runDir = "/run/sourcehut/${serviceName}";
    rootDir = "/run/sourcehut/chroots/${serviceName}";
    in
    mkMerge [ extraService {
    after = [ "network.target" ] ++
      optional cfg.postgresql.enable "postgresql.service" ++
      optional cfg.redis.enable "redis-sourcehut-${srvsrht}.service";
    requires =
      optional cfg.postgresql.enable "postgresql.service" ++
      optional cfg.redis.enable "redis-sourcehut-${srvsrht}.service";
    path = [ pkgs.gawk ];
    environment.HOME = runDir;
    serviceConfig = {
      User = mkDefault srvCfg.user;
      Group = mkDefault srvCfg.group;
      RuntimeDirectory = [
        "sourcehut/${serviceName}"
        # Used by *srht-keys which reads ../config.ini
        "sourcehut/${serviceName}/subdir"
        "sourcehut/chroots/${serviceName}"
      ];
      RuntimeDirectoryMode = "2750";
      # No need for the chroot path once inside the chroot
      InaccessiblePaths = [ "-+${rootDir}" ];
      # g+rx is for group members (eg. fcgiwrap or nginx)
      # to read Git/Mercurial repositories, buildlogs, etc.
      # o+x is for intermediate directories created by BindPaths= and like,
      # as they're owned by root:root.
      UMask = "0026";
      RootDirectory = rootDir;
      RootDirectoryStartOnly = true;
      PrivateTmp = true;
      MountAPIVFS = true;
      # config.ini is looked up in there, before /etc/srht/config.ini
      # Note that it fails to be set in ExecStartPre=
      WorkingDirectory = mkDefault ("-"+runDir);
      BindReadOnlyPaths = [
        builtins.storeDir
        "/etc"
        "/run/booted-system"
        "/run/current-system"
        "/run/systemd"
        ] ++
        optional cfg.postgresql.enable "/run/postgresql" ++
        optional cfg.redis.enable "/run/redis-sourcehut-${srvsrht}";
      # LoadCredential= are unfortunately not available in ExecStartPre=
      # Hence this one is run as root (the +) with RootDirectoryStartOnly=
      # to reach credentials wherever they are.
      # Note that each systemd service gets its own ${runDir}/config.ini file.
      ExecStartPre = mkBefore [("+"+pkgs.writeShellScript "${serviceName}-credentials" ''
        set -x
        # Replace values begining with a '<' by the content of the file whose name is after.
        gawk '{ if (match($0,/^([^=]+=)<(.+)/,m)) { getline f < m[2]; print m[1] f } else print $0 }' ${configIni} |
        ${optionalString (!allowStripe) "gawk '!/^stripe-secret-key=/' |"}
        install -o ${srvCfg.user} -g root -m 400 /dev/stdin ${runDir}/config.ini
      '')];
      # The following options are only for optimizing:
      # systemd-analyze security
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      # ProtectClock= adds DeviceAllow=char-rtc r
      DeviceAllow = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateNetwork = mkDefault false;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      #SocketBindAllow = [ "tcp:${toString srvCfg.port}" "tcp:${toString srvCfg.prometheusPort}" ];
      #SocketBindDeny = "any";
      SystemCallFilter = [
        "@system-service"
        "~@aio" "~@keyring" "~@memlock" "~@privileged" "~@resources" "~@timer"
        "@chown" "@setuid"
      ];
      SystemCallArchitectures = "native";
    };
  } ];
in
{
  options.services.sourcehut.${srv} = {
    enable = mkEnableOption "${srv} service";

    user = mkOption {
      type = types.str;
      default = srvsrht;
      description = lib.mdDoc ''
        User for ${srv}.sr.ht.
      '';
    };

    group = mkOption {
      type = types.str;
      default = srvsrht;
      description = lib.mdDoc ''
        Group for ${srv}.sr.ht.
        Membership grants access to the Git/Mercurial repositories by default,
        but not to the config.ini file (where secrets are).
      '';
    };

    port = mkOption {
      type = types.port;
      default = port;
      description = lib.mdDoc ''
        Port on which the "${srv}" backend should listen.
      '';
    };

    redis = {
      host = mkOption {
        type = types.str;
        default = "unix:///run/redis-sourcehut-${srvsrht}/redis.sock?db=0";
        example = "redis://shared.wireguard:6379/0";
        description = lib.mdDoc ''
          The redis host URL. This is used for caching and temporary storage, and must
          be shared between nodes (e.g. git1.sr.ht and git2.sr.ht), but need not be
          shared between services. It may be shared between services, however, with no
          ill effect, if this better suits your infrastructure.
        '';
      };
    };

    postgresql = {
      database = mkOption {
        type = types.str;
        default = "${srv}.sr.ht";
        description = lib.mdDoc ''
          PostgreSQL database name for the ${srv}.sr.ht service,
          used if [](#opt-services.sourcehut.postgresql.enable) is `true`.
        '';
      };
    };

    gunicorn = {
      extraArgs = mkOption {
        type = with types; listOf str;
        default = ["--timeout 120" "--workers 1" "--log-level=info"];
        description = lib.mdDoc "Extra arguments passed to Gunicorn.";
      };
    };
  } // optionalAttrs webhooks {
    webhooks = {
      extraArgs = mkOption {
        type = with types; listOf str;
        default = ["--loglevel DEBUG" "--pool eventlet" "--without-heartbeat"];
        description = lib.mdDoc "Extra arguments passed to the Celery responsible for webhooks.";
      };
      celeryConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Content of the `celeryconfig.py` used by the Celery responsible for webhooks.";
      };
    };
  };

  config = lib.mkIf (cfg.enable && srvCfg.enable) (mkMerge [ extraConfig {
    users = {
      users = {
        "${srvCfg.user}" = {
          isSystemUser = true;
          group = mkDefault srvCfg.group;
          description = mkDefault "sourcehut user for ${srv}.sr.ht";
        };
      };
      groups = {
        "${srvCfg.group}" = { };
      } // optionalAttrs (cfg.postgresql.enable
        && hasSuffix "0" (postgresql.settings.unix_socket_permissions or "")) {
        "postgres".members = [ srvCfg.user ];
      } // optionalAttrs (cfg.redis.enable
        && hasSuffix "0" (redis.settings.unixsocketperm or "")) {
        "redis-sourcehut-${srvsrht}".members = [ srvCfg.user ];
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      virtualHosts."${srv}.${cfg.settings."sr.ht".global-domain}" = mkMerge [ {
        forceSSL = mkDefault true;
        locations."/".proxyPass = "http://${cfg.listenAddress}:${toString srvCfg.port}";
        locations."/static" = {
          root = "${pkgs.sourcehut.${srvsrht}}/${pkgs.sourcehut.python.sitePackages}/${srvsrht}";
          extraConfig = mkDefault ''
            expires 30d;
          '';
        };
      } cfg.nginx.virtualHost ];
    };

    services.postgresql = mkIf cfg.postgresql.enable {
      authentication = ''
        local ${srvCfg.postgresql.database} ${srvCfg.user} trust
      '';
      ensureDatabases = [ srvCfg.postgresql.database ];
      ensureUsers = map (name: {
          inherit name;
          ensurePermissions = { "DATABASE \"${srvCfg.postgresql.database}\"" = "ALL PRIVILEGES"; };
        }) [srvCfg.user];
    };

    services.sourcehut.services = mkDefault (filter (s: cfg.${s}.enable)
      [ "builds" "dispatch" "git" "hg" "hub" "lists" "man" "meta" "pages" "paste" "todo" ]);

    services.sourcehut.settings = mkMerge [
      {
        "${srv}.sr.ht".origin = mkDefault "https://${srv}.${cfg.settings."sr.ht".global-domain}";
      }

      (mkIf cfg.postgresql.enable {
        "${srv}.sr.ht".connection-string = mkDefault "postgresql:///${srvCfg.postgresql.database}?user=${srvCfg.user}&host=/run/postgresql";
      })
    ];

    services.redis.servers."sourcehut-${srvsrht}" = mkIf cfg.redis.enable {
      enable = true;
      databases = 3;
      syslog = true;
      # TODO: set a more informed value
      save = mkDefault [ [1800 10] [300 100] ];
      settings = {
        # TODO: set a more informed value
        maxmemory = "128MB";
        maxmemory-policy = "volatile-ttl";
      };
    };

    systemd.services = mkMerge [
      {
        "${srvsrht}" = baseService srvsrht { allowStripe = srv == "meta"; } (mkMerge [
        {
          description = "sourcehut ${srv}.sr.ht website service";
          before = optional cfg.nginx.enable "nginx.service";
          wants = optional cfg.nginx.enable "nginx.service";
          wantedBy = [ "multi-user.target" ];
          path = optional cfg.postgresql.enable postgresql.package;
          # Beware: change in credentials' content will not trigger restart.
          restartTriggers = [ configIni ];
          serviceConfig = {
            Type = "simple";
            Restart = mkDefault "always";
            #RestartSec = mkDefault "2min";
            StateDirectory = [ "sourcehut/${srvsrht}" ];
            StateDirectoryMode = "2750";
            ExecStart = "${cfg.python}/bin/gunicorn ${srvsrht}.app:app --name ${srvsrht} --bind ${cfg.listenAddress}:${toString srvCfg.port} " + concatStringsSep " " srvCfg.gunicorn.extraArgs;
          };
          preStart = let
            version = pkgs.sourcehut.${srvsrht}.version;
            stateDir = "/var/lib/sourcehut/${srvsrht}";
            in mkBefore ''
            set -x
            # Use the /run/sourcehut/${srvsrht}/config.ini
            # installed by a previous ExecStartPre= in baseService
            cd /run/sourcehut/${srvsrht}

            if test ! -e ${stateDir}/db; then
              # Setup the initial database.
              # Note that it stamps the alembic head afterward
              ${cfg.python}/bin/${srvsrht}-initdb
              echo ${version} >${stateDir}/db
            fi

            ${optionalString cfg.settings.${iniKey}.migrate-on-upgrade ''
              if [ "$(cat ${stateDir}/db)" != "${version}" ]; then
                # Manage schema migrations using alembic
                ${cfg.python}/bin/${srvsrht}-migrate -a upgrade head
                echo ${version} >${stateDir}/db
              fi
            ''}

            # Update copy of each users' profile to the latest
            # See https://lists.sr.ht/~sircmpwn/sr.ht-admins/<20190302181207.GA13778%40cirno.my.domain>
            if test ! -e ${stateDir}/webhook; then
              # Update ${iniKey}'s users' profile copy to the latest
              ${cfg.python}/bin/srht-update-profiles ${iniKey}
              touch ${stateDir}/webhook
            fi
          '';
        } mainService ]);
      }

      (mkIf webhooks {
        "${srvsrht}-webhooks" = baseService "${srvsrht}-webhooks" {}
          {
            description = "sourcehut ${srv}.sr.ht webhooks service";
            after = [ "${srvsrht}.service" ];
            wantedBy = [ "${srvsrht}.service" ];
            partOf = [ "${srvsrht}.service" ];
            preStart = ''
              cp ${pkgs.writeText "${srvsrht}-webhooks-celeryconfig.py" srvCfg.webhooks.celeryConfig} \
                 /run/sourcehut/${srvsrht}-webhooks/celeryconfig.py
            '';
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              ExecStart = "${cfg.python}/bin/celery --app ${srvsrht}.webhooks worker --hostname ${srvsrht}-webhooks@%%h " + concatStringsSep " " srvCfg.webhooks.extraArgs;
              # Avoid crashing: os.getloadavg()
              ProcSubset = mkForce "all";
            };
          };
      })

      (mapAttrs (timerName: timer: (baseService timerName {} (mkMerge [
        {
          description = "sourcehut ${timerName} service";
          after = [ "network.target" "${srvsrht}.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${cfg.python}/bin/${timerName}";
          };
        }
        (timer.service or {})
      ]))) extraTimers)

      (mapAttrs (serviceName: extraService: baseService serviceName {} (mkMerge [
        {
          description = "sourcehut ${serviceName} service";
          # So that extraServices have the PostgreSQL database initialized.
          after = [ "${srvsrht}.service" ];
          wantedBy = [ "${srvsrht}.service" ];
          partOf = [ "${srvsrht}.service" ];
          serviceConfig = {
            Type = "simple";
            Restart = mkDefault "always";
          };
        }
        extraService
      ])) extraServices)
    ];

    systemd.timers = mapAttrs (timerName: timer:
      {
        description = "sourcehut timer for ${timerName}";
        wantedBy = [ "timers.target" ];
        inherit (timer) timerConfig;
      }) extraTimers;
  } ]);
}
