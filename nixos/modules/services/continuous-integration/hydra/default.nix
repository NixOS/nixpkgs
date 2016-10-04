{ config, pkgs, lib, ... }:

with lib;

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
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"; # Remove in 16.03
      PGPASSFILE = "${baseDir}/pgpass";
      NIX_REMOTE_SYSTEMS = concatStringsSep ":" cfg.buildMachinesFiles;
    } // optionalAttrs (cfg.smtpHost != null) {
      EMAIL_SENDER_TRANSPORT = "SMTP";
      EMAIL_SENDER_TRANSPORT_host = cfg.smtpHost;
    } // hydraEnv // cfg.extraEnv;

  serverEnv = env //
    { HYDRA_TRACKER = cfg.tracker;
      COLUMNS = "80";
      PGPASSFILE = "${baseDir}/pgpass-www"; # grrr
    } // (optionalAttrs cfg.debugServer { DBIC_TRACE = "1"; });

  localDB = "dbi:Pg:dbname=hydra;user=hydra;";

  haveLocalDB = cfg.dbi == localDB;

in

{
  ###### interface
  options = {

    services.hydra = rec {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run Hydra services.
        '';
      };

      dbi = mkOption {
        type = types.str;
        default = localDB;
        example = "dbi:Pg:dbname=hydra;host=postgres.example.org;user=foo;";
        description = ''
          The DBI string for Hydra database connection.
        '';
      };

      package = mkOption {
        type = types.path;
        default = pkgs.hydra;
        defaultText = "pkgs.hydra";
        description = "The Hydra package.";
      };

      hydraURL = mkOption {
        type = types.str;
        description = ''
          The base URL for the Hydra webserver instance. Used for links in emails.
        '';
      };

      listenHost = mkOption {
        type = types.str;
        default = "*";
        example = "localhost";
        description = ''
          The hostname or address to listen on or <literal>*</literal> to listen
          on all interfaces.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 3000;
        description = ''
          TCP port the web server should listen to.
        '';
      };

      minimumDiskFree = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Threshold of minimum disk space (GiB) to determine if the queue runner should run or not.
        '';
      };

      minimumDiskFreeEvaluator = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Threshold of minimum disk space (GiB) to determine if the evaluator should run or not.
        '';
      };

      notificationSender = mkOption {
        type = types.str;
        description = ''
          Sender email address used for email notifications.
        '';
      };

      smtpHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = ["localhost"];
        description = ''
          Hostname of the SMTP server to use to send email.
        '';
      };

      tracker = mkOption {
        type = types.str;
        default = "";
        description = ''
          Piece of HTML that is included on all pages.
        '';
      };

      logo = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to a file containing the logo of your Hydra instance.
        '';
      };

      debugServer = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the server in debug mode.";
      };

      extraConfig = mkOption {
        type = types.lines;
        description = "Extra lines for the Hydra configuration.";
      };

      extraEnv = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Extra environment variables for Hydra.";
      };

      gcRootsDir = mkOption {
        type = types.path;
        default = "/nix/var/nix/gcroots/hydra";
        description = "Directory that holds Hydra garbage collector roots.";
      };

      buildMachinesFiles = mkOption {
        type = types.listOf types.path;
        default = [ "/etc/nix/machines" ];
        example = [ "/etc/nix/machines" "/var/lib/hydra/provisioner/machines" ];
        description = "List of files containing build machines.";
      };

      useSubstitutes = mkOption {
        type = types.bool;
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

  config = mkIf cfg.enable {

    users.extraGroups.hydra = {
      gid = config.ids.gids.hydra;
    };

    users.extraUsers.hydra =
      { description = "Hydra";
        group = "hydra";
        createHome = true;
        home = baseDir;
        useDefaultShell = true;
        uid = config.ids.uids.hydra;
      };

    users.extraUsers.hydra-queue-runner =
      { description = "Hydra queue runner";
        group = "hydra";
        useDefaultShell = true;
        home = "${baseDir}/queue-runner"; # really only to keep SSH happy
        uid = config.ids.uids.hydra-queue-runner;
      };

    users.extraUsers.hydra-www =
      { description = "Hydra web server";
        group = "hydra";
        useDefaultShell = true;
        uid = config.ids.uids.hydra-www;
      };

    nix.trustedUsers = [ "hydra-queue-runner" ];

    services.hydra.extraConfig =
      ''
        using_frontend_proxy 1
        base_uri ${cfg.hydraURL}
        notification_sender ${cfg.notificationSender}
        max_servers 25
        ${optionalString (cfg.logo != null) ''
          hydra_logo ${cfg.logo}
        ''}
        gc_roots_dir ${cfg.gcRootsDir}
      '';

    environment.systemPackages = [ cfg.package ];

    environment.variables = hydraEnv;

    nix.extraOptions = ''
      gc-keep-outputs = true
      gc-keep-derivations = true

      # The default (`true') slows Nix down a lot since the build farm
      # has so many GC roots.
      gc-check-reachability = false
    '';

    systemd.services.hydra-init =
      { wantedBy = [ "multi-user.target" ];
        requires = optional haveLocalDB "postgresql.service";
        after = optional haveLocalDB "postgresql.service";
        environment = env;
        preStart = ''
          mkdir -p ${baseDir}
          chown hydra.hydra ${baseDir}
          chmod 0750 ${baseDir}

          ln -sf ${hydraConf} ${baseDir}/hydra.conf

          mkdir -m 0700 -p ${baseDir}/www
          chown hydra-www.hydra ${baseDir}/www

          mkdir -m 0700 -p ${baseDir}/queue-runner
          mkdir -m 0750 -p ${baseDir}/build-logs
          chown hydra-queue-runner.hydra ${baseDir}/queue-runner ${baseDir}/build-logs

          ${optionalString haveLocalDB ''
            if ! [ -e ${baseDir}/.db-created ]; then
              ${config.services.postgresql.package}/bin/createuser hydra
              ${config.services.postgresql.package}/bin/createdb -O hydra hydra
              touch ${baseDir}/.db-created
            fi
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

          chown hydra.hydra ${cfg.gcRootsDir}
          chmod 2775 ${cfg.gcRootsDir}
        '';
        serviceConfig.ExecStart = "${cfg.package}/bin/hydra-init";
        serviceConfig.PermissionsStartOnly = true;
        serviceConfig.User = "hydra";
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
      };

    systemd.services.hydra-server =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" ];
        environment = serverEnv;
        serviceConfig =
          { ExecStart =
              "@${cfg.package}/bin/hydra-server hydra-server -f -h '${cfg.listenHost}' "
              + "-p ${toString cfg.port} --max_spare_servers 5 --max_servers 25 "
              + "--max_requests 100 ${optionalString cfg.debugServer "-d"}";
            User = "hydra-www";
            PermissionsStartOnly = true;
            Restart = "always";
          };
      };

    systemd.services.hydra-queue-runner =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" "network.target" ];
        path = [ cfg.package pkgs.nettools pkgs.openssh pkgs.bzip2 config.nix.package ];
        environment = env // {
          PGPASSFILE = "${baseDir}/pgpass-queue-runner"; # grrr
          IN_SYSTEMD = "1"; # to get log severity levels
        };
        serviceConfig =
          { ExecStart = "@${cfg.package}/bin/hydra-queue-runner hydra-queue-runner -v --option build-use-substitutes ${if cfg.useSubstitutes then "true" else "false"}";
            ExecStopPost = "${cfg.package}/bin/hydra-queue-runner --unlock";
            User = "hydra-queue-runner";
            Restart = "always";

            # Ensure we can get core dumps.
            LimitCORE = "infinity";
            WorkingDirectory = "${baseDir}/queue-runner";
          };
      };

    systemd.services.hydra-evaluator =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" "network.target" ];
        path = [ pkgs.nettools ];
        environment = env;
        serviceConfig =
          { ExecStart = "@${cfg.package}/bin/hydra-evaluator hydra-evaluator";
            User = "hydra";
            Restart = "always";
            WorkingDirectory = baseDir;
          };
      };

    systemd.services.hydra-update-gc-roots =
      { requires = [ "hydra-init.service" ];
        after = [ "hydra-init.service" ];
        environment = env;
        serviceConfig =
          { ExecStart = "@${cfg.package}/bin/hydra-update-gc-roots hydra-update-gc-roots";
            User = "hydra";
          };
        startAt = "2,14:15";
      };

    systemd.services.hydra-send-stats =
      { wantedBy = [ "multi-user.target" ];
        after = [ "hydra-init.service" ];
        environment = env;
        serviceConfig =
          { ExecStart = "@${cfg.package}/bin/hydra-send-stats hydra-send-stats";
            User = "hydra";
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
      };

    # Periodically compress build logs. The queue runner compresses
    # logs automatically after a step finishes, but this doesn't work
    # if the queue runner is stopped prematurely.
    systemd.services.hydra-compress-logs =
      { path = [ pkgs.bzip2 ];
        script =
          ''
            find /var/lib/hydra/build-logs -type f -name "*.drv" -mtime +3 -size +0c | xargs -r bzip2 -v -f
          '';
        startAt = "Sun 01:45";
      };

    services.postgresql.enable = mkIf haveLocalDB true;

    services.postgresql.identMap = optionalString haveLocalDB
      ''
        hydra-users hydra hydra
        hydra-users hydra-queue-runner hydra
        hydra-users hydra-www hydra
        hydra-users root hydra
      '';

    services.postgresql.authentication = optionalString haveLocalDB
      ''
        local hydra all ident map=hydra-users
      '';

  };

}
