{ config, lib, options, pkgs, utils, ... }:

with lib;

let
  gcfg = config.services.tarsnap;
  opt = options.services.tarsnap;

  configFile = name: cfg: ''
    keyfile ${cfg.keyfile}
    ${optionalString (cfg.cachedir != null) "cachedir ${cfg.cachedir}"}
    ${optionalString cfg.nodump "nodump"}
    ${optionalString cfg.printStats "print-stats"}
    ${optionalString cfg.printStats "humanize-numbers"}
    ${optionalString (cfg.checkpointBytes != null) ("checkpoint-bytes "+cfg.checkpointBytes)}
    ${optionalString cfg.aggressiveNetworking "aggressive-networking"}
    ${concatStringsSep "\n" (map (v: "exclude ${v}") cfg.excludes)}
    ${concatStringsSep "\n" (map (v: "include ${v}") cfg.includes)}
    ${optionalString cfg.lowmem "lowmem"}
    ${optionalString cfg.verylowmem "verylowmem"}
    ${optionalString (cfg.maxbw != null) "maxbw ${toString cfg.maxbw}"}
    ${optionalString (cfg.maxbwRateUp != null) "maxbw-rate-up ${toString cfg.maxbwRateUp}"}
    ${optionalString (cfg.maxbwRateDown != null) "maxbw-rate-down ${toString cfg.maxbwRateDown}"}
  '';
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "tarsnap" "cachedir" ] "Use services.tarsnap.archives.<name>.cachedir")
  ];

  options = {
    services.tarsnap = {
      enable = mkEnableOption "periodic tarsnap backups";

      package = mkPackageOption pkgs "tarsnap" { };

      keyfile = mkOption {
        type = types.str;
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

      archives = mkOption {
        type = types.attrsOf (types.submodule ({ config, options, ... }:
          {
            options = {
              keyfile = mkOption {
                type = types.str;
                default = gcfg.keyfile;
                defaultText = literalExpression "config.${opt.keyfile}";
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

              cachedir = mkOption {
                type = types.nullOr types.path;
                default = "/var/cache/tarsnap/${utils.escapeSystemdPath config.keyfile}";
                defaultText = literalExpression ''
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

              nodump = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Exclude files with the `nodump` flag.
                '';
              };

              printStats = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Print global archive statistics upon completion.
                  The output is available via
                  {command}`systemctl status tarsnap-archive-name`.
                '';
              };

              checkpointBytes = mkOption {
                type = types.nullOr types.str;
                default = "1GB";
                description = ''
                  Create a checkpoint every `checkpointBytes`
                  of uploaded data (optionally specified using an SI prefix).

                  1GB is the minimum value. A higher value is recommended,
                  as checkpointing is expensive.

                  Set to `null` to disable checkpointing.
                '';
              };

              period = mkOption {
                type = types.str;
                default = "01:15";
                example = "hourly";
                description = ''
                  Create archive at this interval.

                  The format is described in
                  {manpage}`systemd.time(7)`.
                '';
              };

              aggressiveNetworking = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Upload data over multiple TCP connections, potentially
                  increasing tarsnap's bandwidth utilisation at the cost
                  of slowing down all other network traffic. Not
                  recommended unless TCP congestion is the dominant
                  limiting factor.
                '';
              };

              directories = mkOption {
                type = types.listOf types.path;
                default = [];
                description = "List of filesystem paths to archive.";
              };

              excludes = mkOption {
                type = types.listOf types.str;
                default = [];
                description = ''
                  Exclude files and directories matching these patterns.
                '';
              };

              includes = mkOption {
                type = types.listOf types.str;
                default = [];
                description = ''
                  Include only files and directories matching these
                  patterns (the empty list includes everything).

                  Exclusions have precedence over inclusions.
                '';
              };

              lowmem = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Reduce memory consumption by not caching small files.
                  Possibly beneficial if the average file size is smaller
                  than 1 MB and the number of files is lower than the
                  total amount of RAM in KB.
                '';
              };

              verylowmem = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Reduce memory consumption by a factor of 2 beyond what
                  `lowmem` does, at the cost of significantly
                  slowing down the archiving process.
                '';
              };

              maxbw = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = ''
                  Abort archival if upstream bandwidth usage in bytes
                  exceeds this threshold.
                '';
              };

              maxbwRateUp = mkOption {
                type = types.nullOr types.int;
                default = null;
                example = literalExpression "25 * 1000";
                description = ''
                  Upload bandwidth rate limit in bytes.
                '';
              };

              maxbwRateDown = mkOption {
                type = types.nullOr types.int;
                default = null;
                example = literalExpression "50 * 1000";
                description = ''
                  Download bandwidth rate limit in bytes.
                '';
              };

              verbose = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether to produce verbose logging output.
                '';
              };
              explicitSymlinks = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether to follow symlinks specified as archives.
                '';
              };
              followSymlinks = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether to follow all symlinks in archive trees.
                '';
              };
            };
          }
        ));

        default = {};

        example = literalExpression ''
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

  config = mkIf gcfg.enable {
    assertions =
      (mapAttrsToList (name: cfg:
        { assertion = cfg.directories != [];
          message = "Must specify paths for tarsnap to back up";
        }) gcfg.archives) ++
      (mapAttrsToList (name: cfg:
        { assertion = !(cfg.lowmem && cfg.verylowmem);
          message = "You cannot set both lowmem and verylowmem";
        }) gcfg.archives);

    systemd.services =
      (mapAttrs' (name: cfg: nameValuePair "tarsnap-${name}" {
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
                        ${optionalString cfg.verbose "-v"} \
                        ${optionalString cfg.explicitSymlinks "-H"} \
                        ${optionalString cfg.followSymlinks "-L"} \
                        ${concatStringsSep " " cfg.directories}'';
          cachedir = escapeShellArg cfg.cachedir;
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

      (mapAttrs' (name: cfg: nameValuePair "tarsnap-restore-${name}"{
        description = "Tarsnap restore '${name}'";
        requires    = [ "network-online.target" ];

        path = with pkgs; [ iputils gcfg.package util-linux ];

        script = let
          tarsnap = ''${lib.getExe gcfg.package} --configfile "/etc/tarsnap/${name}.conf"'';
          lastArchive = "$(${tarsnap} --list-archives | sort | tail -1)";
          run = ''${tarsnap} -x -f "${lastArchive}" ${optionalString cfg.verbose "-v"}'';
          cachedir = escapeShellArg cfg.cachedir;

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
    systemd.timers = mapAttrs' (name: cfg: nameValuePair "tarsnap-${name}"
      { timerConfig.OnCalendar = cfg.period;
        timerConfig.Persistent = "true";
        wantedBy = [ "timers.target" ];
      }) gcfg.archives;

    environment.etc =
      mapAttrs' (name: cfg: nameValuePair "tarsnap/${name}.conf"
        { text = configFile name cfg;
        }) gcfg.archives;

    environment.systemPackages = [ gcfg.package ];
  };
}
