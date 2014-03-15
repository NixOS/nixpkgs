{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.tarsnap;

  optionalNullStr = e: v: if e == null then "" else v;

  configFile = pkgs.writeText "tarsnap.conf" ''
    cachedir ${cfg.cachedir}
    keyfile  ${cfg.keyfile}
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

      label = mkOption {
        type = types.str;
        default = "nixos";
        description = ''
          Specifies the label for archives created by Tarsnap. The
          full name will be
          <literal>label-$(date+"%Y%m%d%H%M%S")</literal>. For
          example, by default your backups will look similar to
          <literal>nixos-20140301011501</literal>.
        '';
      };

      cachedir = mkOption {
        type    = types.path;
        default = "/var/cache/tarsnap";
        description = ''
          Tarsnap operations use a "cache directory" which allows
          Tarsnap to identify which blocks of data have been
          previously stored; this directory is specified via the
          <literal>cachedir</literal> option. If the cache directory
          is lost or out of date, tarsnap creation/deletion operations
          will exit with an error message instructing you to run
          <literal>tarsnap --fsck</literal> to regenerate the cache
          directory.
        '';
      };

      keyfile = mkOption {
        type = types.path;
        default = "/root/tarsnap.key";
        description = ''
          Path to the keyfile which identifies the machine associated
          with your Tarsnap account. This file can be created using
          the <literal>tarsnap-keygen</literal> utility, and providing
          your Tarsnap login credentials.
        '';
      };

      nodump = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If set to <literal>true</literal>, then don't archive files
          which have the <literal>nodump</literal> flag set.
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
          Create a checkpoint per a particular amount of uploaded
          data. By default, Tarsnap will create checkpoints once per
          GB of data uploaded. At minimum,
          <literal>checkpointBytes</literal> must be 1GB.

          Can also be set to <literal>null</literal> to disable
          checkpointing.
        '';
      };

      period = mkOption {
        type = types.str;
        default = "15 01 * * *";
        description = ''
          This option defines (in the format used by cron) when
          tarsnap is run for backups. The default is to backup the
          specified paths at 01:15 at night every day.
        '';
      };

      aggressiveNetworking = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Aggressive network behaviour: Use multiple TCP connections
          when writing archives.  Use of this option is recommended
          only in cases where TCP congestion control is known to be
          the limiting factor in upload performance.
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
          Exclude files and directories matching the specified patterns.
        '';
      };

      includes = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Include only files and directories matching the specified patterns.

          Note that exclusions specified via
          <literal>excludes</literal> take precedence over inclusions.
        '';
      };

      lowmem = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Attempt to reduce tarsnap memory consumption.  This option
          will slow down the process of creating archives, but may
          help on systems where the average size of files being backed
          up is less than 1 MB.
        '';
      };

      verylowmem = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Try even harder to reduce tarsnap memory consumption.  This
          can significantly slow down tarsnap, but reduces its memory
          usage by an additional factor of 2 beyond what the
          <literal>lowmem</literal> option does.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ { assertion = cfg.directories != [];
          message = "Must specify directories for Tarsnap to back up";
        }
        { assertion = cfg.lowmem -> !cfg.verylowmem && (cfg.verylowmem -> !cfg.lowmem);
          message = "You cannot set both lowmem and verylowmem";
        }
      ];

    systemd.services.tarsnap-backup = {
      description = "Tarsnap Backup process";
      path = [ pkgs.tarsnap pkgs.coreutils ];
      script = ''
        mkdir -p -m 0755 $(dirname ${cfg.cachedir})
        mkdir -p -m 0600 ${cfg.cachedir}
        exec tarsnap --configfile ${configFile} -c -f ${cfg.label}-$(date +"%Y%m%d%H%M%S") ${concatStringsSep " " cfg.directories}
      '';
    };

    services.cron.systemCronJobs = optional cfg.enable
      "${cfg.period} root ${config.systemd.package}/bin/systemctl start tarsnap-backup.service";

    environment.systemPackages = [ pkgs.tarsnap ];
  };
}
