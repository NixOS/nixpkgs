{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.locate;
  isMLocate = hasPrefix "mlocate" cfg.locate.name;
  isFindutils = hasPrefix "findutils" cfg.locate.name;
in {
  options.services.locate = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        If enabled, NixOS will periodically update the database of
        files used by the <command>locate</command> command.
      '';
    };

    locate = mkOption {
      type = package;
      default = pkgs.findutils;
      defaultText = "pkgs.findutils";
      example = "pkgs.mlocate";
      description = ''
        The locate implementation to use
      '';
    };

    interval = mkOption {
      type = str;
      default = "02:15";
      example = "hourly";
      description = ''
        Update the locate database at this interval. Updates by
        default at 2:15 AM every day.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    extraFlags = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Extra flags to pass to <command>updatedb</command>.
      '';
    };

    output = mkOption {
      type = path;
      default = "/var/cache/locatedb";
      description = ''
        The database file to build.
      '';
    };

    localuser = mkOption {
      type = nullOr str;
      default = "nobody";
      description = ''
        The user to search non-network directories as, using
        <command>su</command>.
      '';
    };

    pruneFS = mkOption {
      type = listOf str;
      default = ["afs" "anon_inodefs" "auto" "autofs" "bdev" "binfmt" "binfmt_misc" "cgroup" "cifs" "coda" "configfs" "cramfs" "cpuset" "debugfs" "devfs" "devpts" "devtmpfs" "ecryptfs" "eventpollfs" "exofs" "futexfs" "ftpfs" "fuse" "fusectl" "gfs" "gfs2" "hostfs" "hugetlbfs" "inotifyfs" "iso9660" "jffs2" "lustre" "misc" "mqueue" "ncpfs" "nnpfs" "ocfs" "ocfs2" "pipefs" "proc" "ramfs" "rpc_pipefs" "securityfs" "selinuxfs" "sfs" "shfs" "smbfs" "sockfs" "spufs" "nfs" "NFS" "nfs4" "nfsd" "sshfs" "subfs" "supermount" "sysfs" "tmpfs" "ubifs" "udf" "usbfs" "vboxsf" "vperfctrfs" ];
      description = ''
        Which filesystem types to exclude from indexing
      '';
    };

    prunePaths = mkOption {
      type = listOf path;
      default = ["/tmp" "/var/tmp" "/var/cache" "/var/lock" "/var/run" "/var/spool" "/nix/store"];
      description = ''
        Which paths to exclude from indexing
      '';
    };

    pruneNames = mkOption {
      type = listOf str;
      default = [];
      description = ''
        Directory components which should exclude paths containing them from indexing
      '';
    };

    pruneBindMounts = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether not to index bind mounts
      '';
    };
    
  };

  config = mkIf cfg.enable {
    users.extraGroups = mkIf isMLocate { mlocate = {}; };

    security.wrappers = mkIf isMLocate {
      locate = {
        group = "mlocate";
        owner = "root";
        permissions = "u+rx,g+x,o+x";
        setgid = true;
        setuid = false;
        source = "${cfg.locate}/bin/locate";
      };
    };

    nixpkgs.config = { locate.dbfile = cfg.output; };

    environment.systemPackages = [ cfg.locate ];

    environment.variables = mkIf (!isMLocate)
      { LOCATE_PATH = cfg.output;
      };

    warnings = optional (isMLocate && cfg.localuser != null) "mlocate does not support searching as user other than root"
            ++ optional (isFindutils && cfg.pruneNames != []) "findutils locate does not support pruning by directory component"
            ++ optional (isFindutils && cfg.pruneBindMounts) "findutils locate does not support skipping bind mounts";
  
    systemd.services.update-locatedb =
      { description = "Update Locate Database";
        path = mkIf (!isMLocate) [ pkgs.su ];
        script =
          ''
            mkdir -m 0755 -p ${dirOf cfg.output}
            exec ${cfg.locate}/bin/updatedb \
              ${optionalString (cfg.localuser != null && ! isMLocate) ''--localuser=${cfg.localuser}''} \
              --output=${toString cfg.output} ${concatStringsSep " " cfg.extraFlags}
          '';
        environment = {
          PRUNEFS = concatStringsSep " " cfg.pruneFS;
          PRUNEPATHS = concatStringsSep " " cfg.prunePaths;
          PRUNENAMES = concatStringsSep " " cfg.pruneNames;
          PRUNE_BIND_MOUNTS = if cfg.pruneBindMounts then "yes" else "no";
        };
        serviceConfig.Nice = 19;
        serviceConfig.IOSchedulingClass = "idle";
        serviceConfig.PrivateTmp = "yes";
        serviceConfig.PrivateNetwork = "yes";
        serviceConfig.NoNewPrivileges = "yes";
        serviceConfig.ReadOnlyDirectories = "/";
        serviceConfig.ReadWriteDirectories = dirOf cfg.output;
      };

    systemd.timers.update-locatedb =
      { description = "Update timer for locate database";
        partOf      = [ "update-locatedb.service" ];
        wantedBy    = [ "timers.target" ];
        timerConfig.OnCalendar = cfg.interval;
      };
  };
}
