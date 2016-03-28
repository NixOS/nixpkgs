{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tarsnap;

  configFile = name: cfg: ''
    cachedir ${config.services.tarsnap.cachedir}/${name}
    keyfile  ${cfg.keyfile}
    ${optionalString cfg.nodump "nodump"}
    ${optionalString cfg.printStats "print-stats"}
    ${optionalString cfg.printStats "humanize-numbers"}
    ${optionalString (cfg.checkpointBytes != null) ("checkpoint-bytes "+cfg.checkpointBytes)}
    ${optionalString cfg.aggressiveNetworking "aggressive-networking"}
    ${concatStringsSep "\n" (map (v: "exclude "+v) cfg.excludes)}
    ${concatStringsSep "\n" (map (v: "include "+v) cfg.includes)}
    ${optionalString cfg.lowmem "lowmem"}
    ${optionalString cfg.verylowmem "verylowmem"}
    ${optionalString (cfg.maxbw != null) ("maxbw "+toString cfg.maxbw)}
    ${optionalString (cfg.maxbwRateUp != null) ("maxbw-rate-up "+toString cfg.maxbwRateUp)}
    ${optionalString (cfg.maxbwRateDown != null) ("maxbw-rate-down "+toString cfg.maxbwRateDown)}
  '';
in
{
  options = {
    services.tarsnap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable periodic tarsnap backups.
        '';
      };

      keyfile = mkOption {
        type = types.str;
        default = "/root/tarsnap.key";
        description = ''
          The keyfile which associates this machine with your tarsnap
          account.
          Create the keyfile with <command>tarsnap-keygen</command>.

          Note that each individual archive (specified below) may also have its
          own individual keyfile specified. Tarsnap does not allow multiple
          concurrent backups with the same cache directory and key (starting a
          new backup will cause another one to fail). If you have multiple
          archives specified, you should either spread out your backups to be
          far apart, or specify a separate key for each archive. By default
          every archive defaults to using
          <literal>"/root/tarsnap.key"</literal>.

          It's recommended for backups that you generate a key for every archive
          using <literal>tarsnap-keygen(1)</literal>, and then generate a
          write-only tarsnap key using <literal>tarsnap-keymgmt(1)</literal>,
          and keep your master key(s) for a particular machine off-site.

          The keyfile name should be given as a string and not a path, to
          avoid the key being copied into the Nix store.
        '';
      };

      cachedir = mkOption {
        type    = types.nullOr types.path;
        default = "/var/cache/tarsnap";
        description = ''
          The cache allows tarsnap to identify previously stored data
          blocks, reducing archival time and bandwidth usage.

          Should the cache become desynchronized or corrupted, tarsnap
          will refuse to run until you manually rebuild the cache with
          <command>tarsnap --fsck</command>.

          Note that each individual archive (specified below) has its own cache
          directory specified under <literal>cachedir</literal>; this is because
          tarsnap locks the cache during backups, meaning multiple services
          archives cannot be backed up concurrently or overlap with a shared
          cache.

          Set to <literal>null</literal> to disable caching.
        '';
      };

      archives = mkOption {
        type = types.attrsOf (types.submodule (
          {
            options = {
              keyfile = mkOption {
                type = types.str;
                default = config.services.tarsnap.keyfile;
                description = ''
                  Set a specific keyfile for this archive. This defaults to
                  <literal>"/root/tarsnap.key"</literal> if left unspecified.

                  Use this option if you want to run multiple backups
                  concurrently - each archive must have a unique key. You can
                  generate a write-only key derived from your master key (which
                  is recommended) using <literal>tarsnap-keymgmt(1)</literal>.

                  Note: every archive must have an individual master key. You
                  must generate multiple keys with
                  <literal>tarsnap-keygen(1)</literal>, and then generate write
                  only keys from those.

                  The keyfile name should be given as a string and not a path, to
                  avoid the key being copied into the Nix store.
                '';
              };

              nodump = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Exclude files with the <literal>nodump</literal> flag.
                '';
              };

              printStats = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Print global archive statistics upon completion.
                  The output is available via
                  <command>systemctl status tarsnap@archive-name</command>.
                '';
              };

              checkpointBytes = mkOption {
                type = types.nullOr types.str;
                default = "1GB";
                description = ''
                  Create a checkpoint every <literal>checkpointBytes</literal>
                  of uploaded data (optionally specified using an SI prefix).

                  1GB is the minimum value. A higher value is recommended,
                  as checkpointing is expensive.

                  Set to <literal>null</literal> to disable checkpointing.
                '';
              };

              period = mkOption {
                type = types.str;
                default = "01:15";
                example = "hourly";
                description = ''
                  Create archive at this interval.

                  The format is described in
                  <citerefentry><refentrytitle>systemd.time</refentrytitle>
                  <manvolnum>7</manvolnum></citerefentry>.
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
                  <literal>lowmem</literal> does, at the cost of significantly
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
                example = literalExample "25 * 1000";
                description = ''
                  Upload bandwidth rate limit in bytes.
                '';
              };

              maxbwRateDown = mkOption {
                type = types.nullOr types.int;
                default = null;
                example = literalExample "50 * 1000";
                description = ''
                  Download bandwidth rate limit in bytes.
                '';
              };
            };
          }
        ));

        default = {};

        example = literalExample ''
          {
            nixos =
              { directories = [ "/home" "/root/ssl" ];
              };

            gamedata =
              { directories = [ "/var/lib/minecraft "];
                period      = "*:30";
              };
          }
        '';

        description = ''
          Tarsnap archive configurations. Each attribute names an archive
          to be created at a given time interval, according to the options
          associated with it. When uploading to the tarsnap server,
          archive names are suffixed by a 1 second resolution timestamp.

          For each member of the set is created a timer which triggers the
          instanced <literal>tarsnap@</literal> service unit. You may use
          <command>systemctl start tarsnap@archive-name</command> to
          manually trigger creation of <literal>archive-name</literal> at
          any time.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      (mapAttrsToList (name: cfg:
        { assertion = cfg.directories != [];
          message = "Must specify paths for tarsnap to back up";
        }) cfg.archives) ++
      (mapAttrsToList (name: cfg:
        { assertion = !(cfg.lowmem && cfg.verylowmem);
          message = "You cannot set both lowmem and verylowmem";
        }) cfg.archives);

    systemd.services."tarsnap@" = {
      description = "Tarsnap archive '%i'";
      requires    = [ "network-online.target" ];
      after       = [ "network-online.target" ];

      path = [ pkgs.iputils pkgs.tarsnap pkgs.coreutils ];

      # In order for the persistent tarsnap timer to work reliably, we have to
      # make sure that the tarsnap server is reachable after systemd starts up
      # the service - therefore we sleep in a loop until we can ping the
      # endpoint.
      preStart = "while ! ping -q -c 1 v1-0-0-server.tarsnap.com &> /dev/null; do sleep 3; done";
      scriptArgs = "%i";
      script = ''
        mkdir -p -m 0755 ${dirOf cfg.cachedir}
        mkdir -p -m 0700 ${cfg.cachedir}
        chown root:root ${cfg.cachedir}
        chmod 0700 ${cfg.cachedir}
        mkdir -p -m 0700 ${cfg.cachedir}/$1
        DIRS=`cat /etc/tarsnap/$1.dirs`
        exec tarsnap --configfile /etc/tarsnap/$1.conf -c -f $1-$(date +"%Y%m%d%H%M%S") $DIRS
      '';

      serviceConfig = {
        IOSchedulingClass = "idle";
        NoNewPrivileges = "true";
        CapabilityBoundingSet = "CAP_DAC_READ_SEARCH";
        PermissionsStartOnly = "true";
      };
    };

    # Note: the timer must be Persistent=true, so that systemd will start it even
    # if e.g. your laptop was asleep while the latest interval occurred.
    systemd.timers = mapAttrs' (name: cfg: nameValuePair "tarsnap@${name}"
      { timerConfig.OnCalendar = cfg.period;
        timerConfig.Persistent = "true";
        wantedBy = [ "timers.target" ];
      }) cfg.archives;

    environment.etc =
      (mapAttrs' (name: cfg: nameValuePair "tarsnap/${name}.conf"
        { text = configFile name cfg;
        }) cfg.archives) //
      (mapAttrs' (name: cfg: nameValuePair "tarsnap/${name}.dirs"
        { text = concatStringsSep " " cfg.directories;
        }) cfg.archives);

    environment.systemPackages = [ pkgs.tarsnap ];
  };
}
