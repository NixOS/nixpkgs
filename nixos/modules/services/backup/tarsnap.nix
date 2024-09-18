{ config, lib, options, pkgs, utils, ... }:
let
  gcfg = config.services.tarsnap;
  opt = options.services.tarsnap;

  configFile = name: cfg: ''
    keyfile ${cfg.keyfile}
    ${lib.optionalString (cfg.cachedir != null) "cachedir ${cfg.cachedir}"}
    ${lib.optionalString cfg.nodump "nodump"}
    ${lib.optionalString cfg.printStats "print-stats"}
    ${lib.optionalString cfg.printStats "humanize-numbers"}
    ${lib.optionalString (cfg.checkpointBytes != null) ("checkpoint-bytes "+cfg.checkpointBytes)}
    ${lib.optionalString cfg.aggressiveNetworking "aggressive-networking"}
    ${lib.concatStringsSep "\n" (map (v: "exclude ${v}") cfg.excludes)}
    ${lib.concatStringsSep "\n" (map (v: "include ${v}") cfg.includes)}
    ${lib.optionalString cfg.lowmem "lowmem"}
    ${lib.optionalString cfg.verylowmem "verylowmem"}
    ${lib.optionalString (cfg.maxbw != null) "maxbw ${toString cfg.maxbw}"}
    ${lib.optionalString (cfg.maxbwRateUp != null) "maxbw-rate-up ${toString cfg.maxbwRateUp}"}
    ${lib.optionalString (cfg.maxbwRateDown != null) "maxbw-rate-down ${toString cfg.maxbwRateDown}"}
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "tarsnap" "cachedir" ] "Use services.tarsnap.archives.<name>.cachedir")
  ];

  options = {
    services.tarsnap = {
      enable = lib.mkEnableOption "periodic tarsnap backups";

      package = lib.mkPackageOption pkgs "tarsnap" { };

      keyfile = lib.mkOption {
        type = lib.types.str;
        default = "/root/tarsnap.key";
        description = ''
          The keyfile which associates this machine with your tarsnap
          account.
          Create the keyfile with {command}`tarsnap-keygen`.

          Note that each individual archive (specified below) may also have its
          own individual keyfile specified. Tarsnap does not allow multiple
          concurrent backups with the same cache directory and key (starting a
          new backup will cause another one to fail). If you have multiple
          archives specified, you should either spread out your backups to be
          far apart, or specify a separate key for each archive. By default
          every archive defaults to using
          `"/root/tarsnap.key"`.

          It's recommended for backups that you generate a key for every archive
          using `tarsnap-keygen(1)`, and then generate a
          write-only tarsnap key using `tarsnap-keymgmt(1)`,
          and keep your master key(s) for a particular machine off-site.

          The keyfile name should be given as a string and not a path, to
          avoid the key being copied into the Nix store.
        '';
      };

      archives = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule ({ config, options, ... }:
          {
            options = {
              keyfile = lib.mkOption {
                type = lib.types.str;
                default = gcfg.keyfile;
                defaultText = lib.literalExpression "config.${opt.keyfile}";
                description = ''
                  Set a specific keyfile for this archive. This defaults to
                  `"/root/tarsnap.key"` if left unspecified.

                  Use this option if you want to run multiple backups
                  concurrently - each archive must have a unique key. You can
                  generate a write-only key derived from your master key (which
                  is recommended) using `tarsnap-keymgmt(1)`.

                  Note: every archive must have an individual master key. You
                  must generate multiple keys with
                  `tarsnap-keygen(1)`, and then generate write
                  only keys from those.

                  The keyfile name should be given as a string and not a path, to
                  avoid the key being copied into the Nix store.
                '';
              };

              cachedir = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = "/var/cache/tarsnap/${utils.lib.escapeSystemdPath config.keyfile}";
                defaultText = lib.literalExpression ''
                  "/var/cache/tarsnap/''${utils.escapeSystemdPath config.${options.keyfile}}"
                '';
                description = ''
                  The cache allows tarsnap to identify previously stored data
                  blocks, reducing archival time and bandwidth usage.

                  Should the cache become desynchronized or corrupted, tarsnap
                  will refuse to run until you manually rebuild the cache with
                  {command}`tarsnap --fsck`.

                  Set to `null` to disable caching.
                '';
              };

              nodump = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Exclude files with the `nodump` flag.
                '';
              };

              printStats = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Print global archive statistics upon completion.
                  The output is available via
                  {command}`systemctl status tarsnap-archive-name`.
                '';
              };

              checkpointBytes = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = "1GB";
                description = ''
                  Create a checkpoint every `checkpointBytes`
                  of uploaded data (optionally specified using an SI prefix).

                  1GB is the minimum value. A higher value is recommended,
                  as checkpointing is expensive.

                  Set to `null` to disable checkpointing.
                '';
              };

              period = lib.mkOption {
                type = lib.types.str;
                default = "01:15";
                example = "hourly";
                description = ''
                  Create archive at this interval.

                  The format is described in
                  {manpage}`systemd.time(7)`.
                '';
              };

              aggressiveNetworking = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Upload data over multiple TCP connections, potentially
                  increasing tarsnap's bandwidth utilisation at the cost
                  of slowing down all other network traffic. Not
                  recommended unless TCP congestion is the dominant
                  limiting factor.
                '';
              };

              directories = lib.mkOption {
                type = lib.types.listOf lib.types.path;
                default = [];
                description = "List of filesystem paths to archive.";
              };

              excludes = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [];
                description = ''
                  Exclude files and directories matching these patterns.
                '';
              };

              includes = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [];
                description = ''
                  Include only files and directories matching these
                  patterns (the empty list includes everything).

                  Exclusions have precedence over inclusions.
                '';
              };

              lowmem = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Reduce memory consumption by not caching small files.
                  Possibly beneficial if the average file size is smaller
                  than 1 MB and the number of files is lower than the
                  total amount of RAM in KB.
                '';
              };

              verylowmem = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Reduce memory consumption by a factor of 2 beyond what
                  `lowmem` does, at the cost of significantly
                  slowing down the archiving process.
                '';
              };

              maxbw = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
                description = ''
                  Abort archival if upstream bandwidth usage in bytes
                  exceeds this threshold.
                '';
              };

              maxbwRateUp = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
                example = lib.literalExpression "25 * 1000";
                description = ''
                  Upload bandwidth rate limit in bytes.
                '';
              };

              maxbwRateDown = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
                example = lib.literalExpression "50 * 1000";
                description = ''
                  Download bandwidth rate limit in bytes.
                '';
              };

              verbose = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether to produce verbose logging output.
                '';
              };
              explicitSymlinks = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether to follow symlinks specified as archives.
                '';
              };
              followSymlinks = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether to follow all symlinks in archive trees.
                '';
              };
            };
          }
        ));

        default = {};

        example = lib.literalExpression ''
          {
            nixos =
              { directories = [ "/home" "/root/ssl" ];
              };

            gamedata =
              { directories = [ "/var/lib/minecraft" ];
                period      = "*:30";
              };
          }
        '';

        description = ''
          Tarsnap archive configurations. Each attribute names an archive
          to be created at a given time interval, according to the options
          associated with it. When uploading to the tarsnap server,
          archive names are suffixed by a 1 second resolution timestamp,
          with the format `%Y%m%d%H%M%S`.

          For each member of the set is created a timer which triggers the
          instanced `tarsnap-archive-name` service unit. You may use
          {command}`systemctl start tarsnap-archive-name` to
          manually trigger creation of `archive-name` at
          any time.
        '';
      };
    };
  };

  config = lib.mkIf gcfg.enable {
    assertions =
      (lib.mapAttrsToList (name: cfg:
        { assertion = cfg.directories != [];
          message = "Must specify paths for tarsnap to back up";
        }) gcfg.archives) ++
      (lib.mapAttrsToList (name: cfg:
        { assertion = !(cfg.lowmem && cfg.verylowmem);
          message = "You cannot set both lowmem and verylowmem";
        }) gcfg.archives);

    systemd.services =
      (lib.mapAttrs' (name: cfg: lib.nameValuePair "tarsnap-${name}" {
        description = "Tarsnap archive '${name}'";
        requires    = [ "network-online.target" ];
        after       = [ "network-online.target" ];

        path = with pkgs; [ iputils gcfg.package util-linux ];

        # In order for the persistent tarsnap timer to work reliably, we have to
        # make sure that the tarsnap server is reachable after systemd starts up
        # the service - therefore we sleep in a loop until we can ping the
        # endpoint.
        preStart = ''
          while ! ping -4 -q -c 1 v1-0-0-server.tarsnap.com &> /dev/null; do sleep 3; done
        '';

        script = let
          tarsnap = ''${lib.getExe gcfg.package} --configfile "/etc/tarsnap/${name}.conf"'';
          run = ''${tarsnap} -c -f "${name}-$(date +"%Y%m%d%H%M%S")" \
                        ${lib.optionalString cfg.verbose "-v"} \
                        ${lib.optionalString cfg.explicitSymlinks "-H"} \
                        ${lib.optionalString cfg.followSymlinks "-L"} \
                        ${lib.concatStringsSep " " cfg.directories}'';
          cachedir = lib.escapeShellArg cfg.cachedir;
          in if (cfg.cachedir != null) then ''
            mkdir -p ${cachedir}
            chmod 0700 ${cachedir}

            ( flock 9
              if [ ! -e ${cachedir}/firstrun ]; then
                ( flock 10
                  flock -u 9
                  ${tarsnap} --fsck
                  flock 9
                ) 10>${cachedir}/firstrun
              fi
            ) 9>${cachedir}/lockf

             exec flock ${cachedir}/firstrun ${run}
          '' else "exec ${run}";

        serviceConfig = {
          Type = "oneshot";
          IOSchedulingClass = "idle";
          NoNewPrivileges = "true";
          CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
          PermissionsStartOnly = "true";
        };
      }) gcfg.archives) //

      (lib.mapAttrs' (name: cfg: lib.nameValuePair "tarsnap-restore-${name}"{
        description = "Tarsnap restore '${name}'";
        requires    = [ "network-online.target" ];

        path = with pkgs; [ iputils gcfg.package util-linux ];

        script = let
          tarsnap = ''${lib.getExe gcfg.package} --configfile "/etc/tarsnap/${name}.conf"'';
          lastArchive = "$(${tarsnap} --list-archives | sort | tail -1)";
          run = ''${tarsnap} -x -f "${lastArchive}" ${lib.optionalString cfg.verbose "-v"}'';
          cachedir = lib.escapeShellArg cfg.cachedir;

        in if (cfg.cachedir != null) then ''
          mkdir -p ${cachedir}
          chmod 0700 ${cachedir}

          ( flock 9
            if [ ! -e ${cachedir}/firstrun ]; then
              ( flock 10
                flock -u 9
                ${tarsnap} --fsck
                flock 9
              ) 10>${cachedir}/firstrun
            fi
          ) 9>${cachedir}/lockf

           exec flock ${cachedir}/firstrun ${run}
        '' else "exec ${run}";

        serviceConfig = {
          Type = "oneshot";
          IOSchedulingClass = "idle";
          NoNewPrivileges = "true";
          CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
          PermissionsStartOnly = "true";
        };
      }) gcfg.archives);

    # Note: the timer must be Persistent=true, so that systemd will start it even
    # if e.g. your laptop was asleep while the latest interval occurred.
    systemd.timers = lib.mapAttrs' (name: cfg: lib.nameValuePair "tarsnap-${name}"
      { timerConfig.OnCalendar = cfg.period;
        timerConfig.Persistent = "true";
        wantedBy = [ "timers.target" ];
      }) gcfg.archives;

    environment.etc =
      lib.mapAttrs' (name: cfg: lib.nameValuePair "tarsnap/${name}.conf"
        { text = configFile name cfg;
        }) gcfg.archives;

    environment.systemPackages = [ gcfg.package ];
  };
}
