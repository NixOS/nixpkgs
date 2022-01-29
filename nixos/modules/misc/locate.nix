{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.locate;
  isMLocate = hasPrefix "mlocate" cfg.locate.name;
  isPLocate = hasPrefix "plocate" cfg.locate.name;
  isMorPLocate = (isMLocate || isPLocate);
  isFindutils = hasPrefix "findutils" cfg.locate.name;
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "locate" "period" ] [ "services" "locate" "interval" ])
    (mkRemovedOptionModule [ "services" "locate" "includeStore" ] "Use services.locate.prunePaths")
  ];

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
      defaultText = literalExpression "pkgs.findutils";
      example = literalExpression "pkgs.mlocate";
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

        To disable automatic updates, set to <literal>"never"</literal>
        and run <command>updatedb</command> manually.
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
      default = [
        "afs"
        "anon_inodefs"
        "auto"
        "autofs"
        "bdev"
        "binfmt"
        "binfmt_misc"
        "ceph"
        "cgroup"
        "cgroup2"
        "cifs"
        "coda"
        "configfs"
        "cramfs"
        "cpuset"
        "curlftpfs"
        "debugfs"
        "devfs"
        "devpts"
        "devtmpfs"
        "ecryptfs"
        "eventpollfs"
        "exofs"
        "futexfs"
        "ftpfs"
        "fuse"
        "fusectl"
        "fusesmb"
        "fuse.ceph"
        "fuse.glusterfs"
        "fuse.gvfsd-fuse"
        "fuse.mfs"
        "fuse.rclone"
        "fuse.rozofs"
        "fuse.sshfs"
        "gfs"
        "gfs2"
        "hostfs"
        "hugetlbfs"
        "inotifyfs"
        "iso9660"
        "jffs2"
        "lustre"
        "lustre_lite"
        "misc"
        "mfs"
        "mqueue"
        "ncpfs"
        "nfs"
        "NFS"
        "nfs4"
        "nfsd"
        "nnpfs"
        "ocfs"
        "ocfs2"
        "pipefs"
        "proc"
        "ramfs"
        "rpc_pipefs"
        "securityfs"
        "selinuxfs"
        "sfs"
        "shfs"
        "smbfs"
        "sockfs"
        "spufs"
        "sshfs"
        "subfs"
        "supermount"
        "sysfs"
        "tmpfs"
        "tracefs"
        "ubifs"
        "udev"
        "udf"
        "usbfs"
        "vboxsf"
        "vperfctrfs"
      ];
      description = ''
        Which filesystem types to exclude from indexing
      '';
    };

    prunePaths = mkOption {
      type = listOf path;
      default = [
        "/tmp"
        "/var/tmp"
        "/var/cache"
        "/var/lock"
        "/var/run"
        "/var/spool"
        "/nix/store"
        "/nix/var/log/nix"
      ];
      description = ''
        Which paths to exclude from indexing
      '';
    };

    pruneNames = mkOption {
      type = listOf str;
      default = [ ".bzr" ".cache" ".git" ".hg" ".svn" ];
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
    users.groups = mkMerge [
      (mkIf isMLocate { mlocate = { }; })
      (mkIf isPLocate { plocate = { }; })
    ];

    security.wrappers =
      let
        common = {
          owner = "root";
          permissions = "u+rx,g+x,o+x";
          setgid = true;
          setuid = false;
        };
        mlocate = (mkIf isMLocate {
          group = "mlocate";
          source = "${cfg.locate}/bin/locate";
        });
        plocate = (mkIf isPLocate {
          group = "plocate";
          source = "${cfg.locate}/bin/plocate";
        });
      in
      mkIf isMorPLocate {
        locate = mkMerge [ common mlocate plocate ];
        plocate = (mkIf isPLocate (mkMerge [ common plocate ]));
      };

    nixpkgs.config = { locate.dbfile = cfg.output; };

    environment.systemPackages = [ cfg.locate ];

    environment.variables = mkIf (!isMorPLocate) { LOCATE_PATH = cfg.output; };

    environment.etc = {
      # write /etc/updatedb.conf for manual calls to `updatedb`
      "updatedb.conf" = {
        text = ''
          PRUNEFS="${lib.concatStringsSep " " cfg.pruneFS}"
          PRUNENAMES="${lib.concatStringsSep " " cfg.pruneNames}"
          PRUNEPATHS="${lib.concatStringsSep " " cfg.prunePaths}"
          PRUNE_BIND_MOUNTS="${if cfg.pruneBindMounts then "yes" else "no"}"
        '';
      };
    };

    warnings = optional (isMorPLocate && cfg.localuser != null)
      "mlocate does not support the services.locate.localuser option; updatedb will run as root. (Silence with services.locate.localuser = null.)"
    ++ optional (isFindutils && cfg.pruneNames != [ ])
      "findutils locate does not support pruning by directory component"
    ++ optional (isFindutils && cfg.pruneBindMounts)
      "findutils locate does not support skipping bind mounts";

    systemd.services.update-locatedb = {
      description = "Update Locate Database";
      path = mkIf (!isMorPLocate) [ pkgs.su ];

      # mlocate's updatedb takes flags via a configuration file or
      # on the command line, but not by environment variable.
      script =
        if isMorPLocate then
          let
            toFlags = x:
              optional (cfg.${x} != [ ])
                "--${lib.toLower x} '${concatStringsSep " " cfg.${x}}'";
            args = concatLists (map toFlags [ "pruneFS" "pruneNames" "prunePaths" ]);
          in
          ''
            exec ${cfg.locate}/bin/updatedb \
              --output ${toString cfg.output} ${concatStringsSep " " args} \
              --prune-bind-mounts ${if cfg.pruneBindMounts then "yes" else "no"} \
              ${concatStringsSep " " cfg.extraFlags}
          ''
        else ''
          exec ${cfg.locate}/bin/updatedb \
            ${optionalString (cfg.localuser != null && !isMorPLocate) "--localuser=${cfg.localuser}"} \
            --output=${toString cfg.output} ${concatStringsSep " " cfg.extraFlags}
        '';
      environment = optionalAttrs (!isMorPLocate) {
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
      serviceConfig.ReadOnlyPaths = "/";
      # Use dirOf cfg.output because mlocate creates temporary files next to
      # the actual database. We could specify and create them as well,
      # but that would make this quite brittle when they change something.
      # NOTE: If /var/cache does not exist, this leads to the misleading error message:
      # update-locatedb.service: Failed at step NAMESPACE spawning …/update-locatedb-start: No such file or directory
      serviceConfig.ReadWritePaths = dirOf cfg.output;
    };

    systemd.timers.update-locatedb = mkIf (cfg.interval != "never") {
      description = "Update timer for locate database";
      partOf = [ "update-locatedb.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.interval;
    };
  };

  meta.maintainers = with lib.maintainers; [ SuperSandro2000 ];
}
