{ config, pkgs, lib, ... }:
let

  cfg = config.services.hydra;

  baseDir = "/var/lib/hydra";

  hydraConf = pkgs.writeScript "hydra.conf" cfg.extraConfig;

  hydraEnv =
    { HYDRA_DBI = cfg.dbi;
      HYDRA_CONFIG = "${baseDir}/hydra.conf";
      HYDRA_DATA = "${baseDir}";
    };

  env =
    { NIX_REMOTE = "daemon";
      PGPASSFILE = "${baseDir}/pgpass";
      NIX_REMOTE_SYSTEMS = lib.concatStringsSep ":" cfg.buildMachinesFiles;
    } // lib.optionalAttrs (cfg.smtpHost != null) {
      EMAIL_SENDER_TRANSPORT = "SMTP";
      EMAIL_SENDER_TRANSPORT_host = cfg.smtpHost;
    } // hydraEnv // cfg.extraEnv;

  serverEnv = env //
    { HYDRA_TRACKER = cfg.tracker;
      XDG_CACHE_HOME = "${baseDir}/www/.cache";
      COLUMNS = "80";
      PGPASSFILE = "${baseDir}/pgpass-www"; # grrr
    } // (lib.optionalAttrs cfg.debugServer { DBIC_TRACE = "1"; });

  localDB = "dbi:Pg:dbname=hydra;user=hydra;";

  haveLocalDB = cfg.dbi == localDB;

  hydra-package =
  let
    makeWrapperArgs = lib.concatStringsSep " " (lib.mapAttrsToList (key: value: "--set-default \"${key}\" \"${value}\"") hydraEnv);
  in pkgs.buildEnv rec {
    name = "hydra-env";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    paths = [ cfg.package ];

    postBuild = ''
      if [ -L "$out/bin" ]; then
          unlink "$out/bin"
      fi
      mkdir -p "$out/bin"

      for path in ${lib.concatStringsSep " " paths}; do
        if [ -d "$path/bin" ]; then
          cd "$path/bin"
          for prg in *; do
            if [ -f "$prg" ]; then
              rm -f "$out/bin/$prg"
              if [ -x "$prg" ]; then
                makeWrapper "$path/bin/$prg" "$out/bin/$prg" ${makeWrapperArgs}
              fi
            fi
          done
        fi
      done
   '';
  };

in

{
  ###### interface
  options = {

    services.hydra = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run Hydra services.
        '';
      };

      dbi = lib.mkOption {
        type = lib.types.str;
        default = localDB;
        example = "dbi:Pg:dbname=hydra;host=postgres.example.org;user=foo;";
        description = ''
          The DBI string for Hydra database connection.

          NOTE: Attempts to set `application_name` will be overridden by
          `hydra-TYPE` (where TYPE is e.g. `evaluator`, `queue-runner`,
          etc.) in all hydra services to more easily distinguish where
          queries are coming from.
        '';
      };

      package = lib.mkPackageOption pkgs "hydra" { };

      hydraURL = lib.mkOption {
        type = lib.types.str;
        description = ''
          The base URL for the Hydra webserver instance. Used for links in emails.
        '';
      };

      listenHost = lib.mkOption {
        type = lib.types.str;
        default = "*";
        example = "localhost";
        description = ''
          The hostname or address to listen on or `*` to listen
          on all interfaces.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = ''
          TCP port the web server should listen to.
        '';
      };

      minimumDiskFree = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Threshold of minimum disk space (GiB) to determine if the queue runner should run or not.
        '';
      };

      minimumDiskFreeEvaluator = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Threshold of minimum disk space (GiB) to determine if the evaluator should run or not.
        '';
      };

      notificationSender = lib.mkOption {
        type = lib.types.str;
        description = ''
          Sender email address used for email notifications.
        '';
      };

      smtpHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "localhost";
        description = ''
          Hostname of the SMTP server to use to send email.
        '';
      };

      tracker = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Piece of HTML that is included on all pages.
        '';
      };

      logo = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the logo of your Hydra instance.
        '';
      };

      debugServer = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the server in debug mode.";
      };

      maxServers = lib.mkOption {
        type = lib.types.int;
        default = 25;
        description = "Maximum number of starman workers to spawn.";
      };

      minSpareServers = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Minimum number of spare starman workers to keep.";
      };

      maxSpareServers = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Maximum number of spare starman workers to keep.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        description = "Extra lines for the Hydra configuration.";
      };

      extraEnv = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Extra environment variables for Hydra.";
      };

      gcRootsDir = lib.mkOption {
        type = lib.types.path;
        default = "/nix/var/nix/gcroots/hydra";
        description = "Directory that holds Hydra garbage collector roots.";
      };

      buildMachinesFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = lib.optional (config.nix.buildMachines != []) "/etc/nix/machines";
        defaultText = lib.literalExpression ''lib.optional (config.nix.buildMachines != []) "/etc/nix/machines"'';
        example = [ "/etc/nix/machines" "/var/lib/hydra/provisioner/machines" ];
        description = "List of files containing build machines.";
      };

      useSubstitutes = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use binary caches for downloading store paths. Note that
          binary substitutions trigger (a potentially large number of) additional
          HTTP requests that slow down the queue monitor thread significantly.
          Also, this Hydra instance will serve those downloaded store paths to
          its users with its own signature attached as if it had built them
          itself, so don't enable this feature unless your active binary caches
          are absolute trustworthy.
        '';
      };
    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.maxServers != 0 && cfg.maxSpareServers != 0 && cfg.minSpareServers != 0;
        message = "services.hydra.{minSpareServers,maxSpareServers,minSpareServers} cannot be 0";
      }
      {
        assertion = cfg.minSpareServers < cfg.maxSpareServers;
        message = "services.hydra.minSpareServers cannot be bigger than services.hydra.maxSpareServers";
      }
    ];

    users.groups.hydra = {
      gid = config.ids.gids.hydra;
    };

    users.users.hydra =
      { description = "Hydra";
        group = "hydra";
        # We don't enable `createHome` here because the creation of the home directory is handled by the hydra-init service below.
        home = baseDir;
        useDefaultShell = true;
        uid = config.ids.uids.hydra;
      };

    users.users.hydra-queue-runner =
      { description = "Hydra queue runner";
        group = "hydra";
        useDefaultShell = true;
        home = "${baseDir}/queue-runner"; # really only to keep SSH happy
        uid = config.ids.uids.hydra-queue-runner;
      };

    users.users.hydra-www =
      { description = "Hydra web server";
        group = "hydra";
        useDefaultShell = true;
        uid = config.ids.uids.hydra-www;
      };

    services.hydra.extraConfig =
      ''
        using_frontend_proxy = 1
        base_uri = ${cfg.hydraURL}
        notification_sender = ${cfg.notificationSender}
        max_servers = ${toString cfg.maxServers}
        ${lib.optionalString (cfg.logo != null) ''
          hydra_logo = ${cfg.logo}
        ''}
        gc_roots_dir = ${cfg.gcRootsDir}
        use-substitutes = ${if cfg.useSubstitutes then "1" else "0"}
      '';

    environment.systemPackages = [ hydra-package ];

    environment.variables = hydraEnv;

    nix.settings = lib.mkMerge [
      {
        keep-outputs = true;
        keep-derivations = true;
        trusted-users = [ "hydra-queue-runner" ];
      }

      (lib.mkIf (lib.versionOlder (lib.getVersion config.nix.package.out) "2.4pre")
        {
          # The default (`true') slows Nix down a lot since the build farm
          # has so many GC roots.
          gc-check-reachability = false;
        }
      )
    ];

    systemd.slices.system-hydra = {
      description = "Hydra Slice";
      documentation = [ "file://${cfg.package}/share/doc/hydra/index.html" "https://nixos.org/hydra/manual/" ];
    };

    systemd.services.hydra-init =
      { wantedBy = [ "multi-user.target" ];
        requires = lib.optional haveLocalDB "postgresql.service";
        after = lib.optional haveLocalDB "postgresql.service";
        environment = env // {
          HYDRA_DBI = "${env.HYDRA_DBI};application_name=hydra-init";
        };
        path = [ pkgs.util-linux ];
        preStart = ''
          mkdir -p ${baseDir}
          chown hydra:hydra ${baseDir}
          chmod 0750 ${baseDir}

          ln -sf ${hydraConf} ${baseDir}/hydra.conf

          mkdir -m 0700 -p ${baseDir}/www
          chown hydra-www:hydra ${baseDir}/www

          mkdir -m 0700 -p ${baseDir}/queue-runner
          mkdir -m 0750 -p ${baseDir}/build-logs
          mkdir -m 0750 -p ${baseDir}/runcommand-logs
          chown hydra-queue-runner:hydra \
            ${baseDir}/queue-runner \
            ${baseDir}/build-logs \
            ${baseDir}/runcommand-logs

          ${lib.optionalString haveLocalDB ''
            if ! [ -e ${baseDir}/.db-created ]; then
              runuser -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createuser hydra
              runuser -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createdb -- -O hydra hydra
              touch ${baseDir}/.db-created
            fi
            echo "create extension if not exists pg_trgm" | runuser -u ${config.services.postgresql.superUser} -- ${config.services.postgresql.package}/bin/psql hydra
          ''}

          if [ ! -e ${cfg.gcRootsDir} ]; then

            # Move legacy roots directory.
            if [ -e /nix/var/nix/gcroots/per-user/hydra/hydra-roots ]; then
              mv /nix/var/nix/gcroots/per-user/hydra/hydra-roots ${cfg.gcRootsDir}
            fi

            mkdir -p ${cfg.gcRootsDir}
          fi

          # Move legacy hydra-www roots.
          if [ -e /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots ]; then
            find /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots/ -type f \
              | xargs -r mv -f -t ${cfg.gcRootsDir}/
            rmdir /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots
          fi

          chown hydra:hydra ${cfg.gcRootsDir}
          chmod 2775 ${cfg.gcRootsDir}
        '';
        serviceConfig.ExecStart = "${hydra-package}/bin/hydra-init";
        serviceConfig.PermissionsStartOnly = true;
        serviceConfig.User = "hydra";
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        serviceConfig.Slice = "system-hydra.slice";
      };

    systemd.services.hydra-server =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" ];
        environment = serverEnv // {
          HYDRA_DBI = "${serverEnv.HYDRA_DBI};application_name=hydra-server";
        };
        restartTriggers = [ hydraConf ];
        serviceConfig =
          { ExecStart =
              "@${hydra-package}/bin/hydra-server hydra-server -f -h '${cfg.listenHost}' "
              + "-p ${toString cfg.port} --min_spare_servers ${toString cfg.minSpareServers} --max_spare_servers ${toString cfg.maxSpareServers} "
              + "--max_servers ${toString cfg.maxServers} --max_requests 100 ${lib.optionalString cfg.debugServer "-d"}";
            User = "hydra-www";
            PermissionsStartOnly = true;
            Restart = "always";
            Slice = "system-hydra.slice";
          };
      };

    systemd.services.hydra-queue-runner =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" "network.target" ];
        path = [ hydra-package pkgs.nettools pkgs.openssh pkgs.bzip2 config.nix.package ];
        restartTriggers = [ hydraConf ];
        environment = env // {
          PGPASSFILE = "${baseDir}/pgpass-queue-runner"; # grrr
          IN_SYSTEMD = "1"; # to get log severity levels
          HYDRA_DBI = "${env.HYDRA_DBI};application_name=hydra-queue-runner";
        };
        serviceConfig =
          { ExecStart = "@${hydra-package}/bin/hydra-queue-runner hydra-queue-runner -v";
            ExecStopPost = "${hydra-package}/bin/hydra-queue-runner --unlock";
            User = "hydra-queue-runner";
            Restart = "always";
            Slice = "system-hydra.slice";

            # Ensure we can get core dumps.
            LimitCORE = "infinity";
            WorkingDirectory = "${baseDir}/queue-runner";
          };
      };

    systemd.services.hydra-evaluator =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        wants = [ "network-online.target" ];
        after = [ "hydra-init.service" "network.target" "network-online.target" ];
        path = with pkgs; [ hydra-package nettools jq ];
        restartTriggers = [ hydraConf ];
        environment = env // {
          HYDRA_DBI = "${env.HYDRA_DBI};application_name=hydra-evaluator";
        };
        serviceConfig =
          { ExecStart = "@${hydra-package}/bin/hydra-evaluator hydra-evaluator";
            User = "hydra";
            Restart = "always";
            WorkingDirectory = baseDir;
            Slice = "system-hydra.slice";
          };
      };

    systemd.services.hydra-update-gc-roots =
      { requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" ];
        environment = env // {
          HYDRA_DBI = "${env.HYDRA_DBI};application_name=hydra-update-gc-roots";
        };
        serviceConfig =
          { ExecStart = "@${hydra-package}/bin/hydra-update-gc-roots hydra-update-gc-roots";
            User = "hydra";
            Slice = "system-hydra.slice";
          };
        startAt = "2,14:15";
      };

    systemd.services.hydra-send-stats =
      { wantedBy = [ "multi-user.target" ];
        after = [ "hydra-init.service" ];
        environment = env // {
          HYDRA_DBI = "${env.HYDRA_DBI};application_name=hydra-send-stats";
        };
        serviceConfig =
          { ExecStart = "@${hydra-package}/bin/hydra-send-stats hydra-send-stats";
            User = "hydra";
            Slice = "system-hydra.slice";
          };
      };

    systemd.services.hydra-notify =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" ];
        restartTriggers = [ hydraConf ];
        path = [ pkgs.zstd ];
        environment = env // {
          PGPASSFILE = "${baseDir}/pgpass-queue-runner";
          HYDRA_DBI = "${env.HYDRA_DBI};application_name=hydra-notify";
        };
        serviceConfig =
          { ExecStart = "@${hydra-package}/bin/hydra-notify hydra-notify";
            # FIXME: run this under a less privileged user?
            User = "hydra-queue-runner";
            Restart = "always";
            RestartSec = 5;
            Slice = "system-hydra.slice";
          };
      };

    # If there is less than a certain amount of free disk space, stop
    # the queue/evaluator to prevent builds from failing or aborting.
    systemd.services.hydra-check-space =
      { script =
          ''
            if [ $(($(stat -f -c '%a' /nix/store) * $(stat -f -c '%S' /nix/store))) -lt $((${toString cfg.minimumDiskFree} * 1024**3)) ]; then
                echo "stopping Hydra queue runner due to lack of free space..."
                systemctl stop hydra-queue-runner
            fi
            if [ $(($(stat -f -c '%a' /nix/store) * $(stat -f -c '%S' /nix/store))) -lt $((${toString cfg.minimumDiskFreeEvaluator} * 1024**3)) ]; then
                echo "stopping Hydra evaluator due to lack of free space..."
                systemctl stop hydra-evaluator
            fi
          '';
        startAt = "*:0/5";
        serviceConfig.Slice = "system-hydra.slice";
      };

    # Periodically compress build logs. The queue runner compresses
    # logs automatically after a step finishes, but this doesn't work
    # if the queue runner is stopped prematurely.
    systemd.services.hydra-compress-logs =
      { path = [ pkgs.bzip2 pkgs.zstd ];
        script =
          ''
            set -eou pipefail
            compression=$(sed -nr 's/compress_build_logs_compression = ()/\1/p' ${baseDir}/hydra.conf)
            if [[ $compression == zstd ]]; then
              compression="zstd --rm"
            fi
            find ${baseDir}/build-logs -type f -name "*.drv" -mtime +3 -size +0c | xargs -r $compression --force --quiet
          '';
        startAt = "Sun 01:45";
        serviceConfig.Slice = "system-hydra.slice";
      };

    services.postgresql.enable = lib.mkIf haveLocalDB true;

    services.postgresql.identMap = lib.optionalString haveLocalDB
      ''
        hydra-users hydra hydra
        hydra-users hydra-queue-runner hydra
        hydra-users hydra-www hydra
        hydra-users root hydra
        # The postgres user is used to create the pg_trgm extension for the hydra database
        hydra-users postgres postgres
      '';

    services.postgresql.authentication = lib.optionalString haveLocalDB
      ''
        local hydra all ident map=hydra-users
      '';

  };

}
