{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tarsnap;

  optionalNullStr = e: v: if e == null then "" else v;

  configFile = cfg: ''
    cachedir ${config.services.tarsnap.cachedir}
    keyfile  ${config.services.tarsnap.keyfile}
    ${optionalString cfg.nodump "nodump"}
    ${optionalString cfg.printStats "print-stats"}
    ${optionalNullStr cfg.checkpointBytes "checkpoint-bytes "+cfg.checkpointBytes}
    ${optionalString cfg.aggressiveNetworking "aggressive-networking"}
    ${concatStringsSep "\n" (map (v: "exclude "+v) cfg.excludes)}
    ${concatStringsSep "\n" (map (v: "include "+v) cfg.includes)}
    ${optionalString cfg.lowmem "lowmem"}
    ${optionalString cfg.verylowmem "verylowmem"}
  '';
in
{
  options = {
    services.tarsnap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, NixOS will periodically create backups of the
          specified directories using the <literal>tarsnap</literal>
          backup service. This installs a <literal>systemd</literal>
          service called <literal>tarsnap-backup</literal> which is
          periodically run by cron, or you may run it on-demand.

          See the Tarsnap <link
          xlink:href='http://www.tarsnap.com/gettingstarted.html'>Getting
          Started</link> page.
        '';
      };

      keyfile = mkOption {
        type = types.path;
        default = "/root/tarsnap.key";
        description = ''
          Path to the keyfile which identifies the machine
          associated with your Tarsnap account. This file can
          be created using the
          <literal>tarsnap-keygen</literal> utility, and
          providing your Tarsnap login credentials.
        '';
      };

      cachedir = mkOption {
        type    = types.path;
        default = "/var/cache/tarsnap";
        description = ''
          Tarsnap operations use a "cache directory" which
          allows Tarsnap to identify which blocks of data have
          been previously stored; this directory is specified
          via the <literal>cachedir</literal> option. If the
          cache directory is lost or out of date, tarsnap
          creation/deletion operations will exit with an error
          message instructing you to run <literal>tarsnap
          --fsck</literal> to regenerate the cache directory.
        '';
      };

      config = mkOption {
        type = types.attrsOf (types.submodule (
          {
            options = {
              nodump = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  If set to <literal>true</literal>, then don't
                  archive files which have the
                  <literal>nodump</literal> flag set.
                '';
              };

              printStats = mkOption {
                type = types.bool;
                default = true;
                description = "Print statistics when creating archives.";
              };

              checkpointBytes = mkOption {
                type = types.nullOr types.str;
                default = "1G";
                description = ''
                  Create a checkpoint per a particular amount of
                  uploaded data. By default, Tarsnap will create
                  checkpoints once per GB of data uploaded. At
                  minimum, <literal>checkpointBytes</literal> must be
                  1GB.

                  Can also be set to <literal>null</literal> to
                  disable checkpointing.
                '';
              };

              period = mkOption {
                type = types.str;
                default = "15 01 * * *";
                description = ''
                  This option defines (in the format used by cron)
                  when tarsnap is run for backups. The default is to
                  backup the specified paths at 01:15 at night every
                  day.
                '';
              };

              aggressiveNetworking = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Aggressive network behaviour: Use multiple TCP
                  connections when writing archives.  Use of this
                  option is recommended only in cases where TCP
                  congestion control is known to be the limiting
                  factor in upload performance.
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
                  Exclude files and directories matching the specified
                  patterns.
                '';
              };

              includes = mkOption {
                type = types.listOf types.str;
                default = [];
                description = ''
                  Include only files and directories matching the
                  specified patterns.

                  Note that exclusions specified via
                  <literal>excludes</literal> take precedence over
                  inclusions.
                '';
              };

              lowmem = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Attempt to reduce tarsnap memory consumption.  This
                  option will slow down the process of creating
                  archives, but may help on systems where the average
                  size of files being backed up is less than 1 MB.
                '';
              };

              verylowmem = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Try even harder to reduce tarsnap memory
                  consumption.  This can significantly slow down
                  tarsnap, but reduces its memory usage by an
                  additional factor of 2 beyond what the
                  <literal>lowmem</literal> option does.
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
                period      = "*/30 * * * *";
              };
          }
        '';

        description = ''
          Configuration of a Tarsnap archive. In the example, your
          machine will have two tarsnap archives:
          <literal>gamedata</literal> (backed up every 30 minutes) and
          <literal>nixos</literal> (backed up at 1:15 AM every night by
          default). You can control individual archive backups using
          <literal>systemctl</literal>, using the
          <literal>tarsnap@nixos</literal> or
          <literal>tarsnap@gamedata</literal> units. For example,
          <literal>systemctl start tarsnap@nixos</literal> will
          immediately create a new NixOS archive. By default, archives
          are suffixed with the timestamp of when they were started,
          down to second resolution. This means you can use GNU
          <literal>sort</literal> to sort output easily.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      (mapAttrsToList (name: cfg:
        { assertion = cfg.directories != [];
          message = "Must specify directories for Tarsnap to back up";
        }) cfg.config) ++
      (mapAttrsToList (name: cfg:
        { assertion = cfg.lowmem -> !cfg.verylowmem && (cfg.verylowmem -> !cfg.lowmem);
          message = "You cannot set both lowmem and verylowmem";
        }) cfg.config);

    systemd.services."tarsnap@" = {
      description = "Tarsnap Backup of '%i'";
      requires    = [ "network.target" ];

      path = [ pkgs.tarsnap pkgs.coreutils ];
      scriptArgs = "%i";
      script = ''
        mkdir -p -m 0755 $(dirname ${cfg.cachedir})
        mkdir -p -m 0600 ${cfg.cachedir}
        DIRS=`cat /etc/tarsnap/$1.dirs`
        exec tarsnap --configfile /etc/tarsnap/$1.conf -c -f $1-$(date +"%Y%m%d%H%M%S") $DIRS
      '';
    };

    services.cron.systemCronJobs = mapAttrsToList (name: cfg:
      "${cfg.period} root ${config.systemd.package}/bin/systemctl start tarsnap@${name}"
    ) cfg.config;

    environment.etc =
      (mapAttrs' (name: cfg: nameValuePair "tarsnap/${name}.conf"
        { text = configFile cfg;
        }) cfg.config) //
      (mapAttrs' (name: cfg: nameValuePair "tarsnap/${name}.dirs"
        { text = concatStringsSep " " cfg.directories;
        }) cfg.config);

    environment.systemPackages = [ pkgs.tarsnap ];
  };
}
