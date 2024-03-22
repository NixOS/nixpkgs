{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nfs.server;

  exports = pkgs.writeText "exports" cfg.exports;

in

{
  imports = [
    (mkRenamedOptionModule [ "services" "nfs" "lockdPort" ] [ "services" "nfs" "server" "lockdPort" ])
    (mkRenamedOptionModule [ "services" "nfs" "statdPort" ] [ "services" "nfs" "server" "statdPort" ])
  ];

  ###### interface

  options = {

    services.nfs = {

      server = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Whether to enable the kernel's NFS server.
          '';
        };

        extraNfsdConfig = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc ''
            Extra configuration options for the [nfsd] section of /etc/nfs.conf.
          '';
        };

        exports = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc ''
            Contents of the /etc/exports file.  See
            {manpage}`exports(5)` for the format.
          '';
        };

        hostName = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc ''
            Hostname or address on which NFS requests will be accepted.
            Default is all.  See the {option}`-H` option in
            {manpage}`nfsd(8)`.
          '';
        };

        nproc = mkOption {
          type = types.int;
          default = 8;
          description = lib.mdDoc ''
            Number of NFS server threads.  Defaults to the recommended value of 8.
          '';
        };

        createMountPoints = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Whether to create the mount points in the exports file at startup time.";
        };

        mountdPort = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 4002;
          description = lib.mdDoc ''
            Use fixed port for rpc.mountd, useful if server is behind firewall.
          '';
        };

        lockdPort = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 4001;
          description = lib.mdDoc ''
            Use a fixed port for the NFS lock manager kernel module
            (`lockd/nlockmgr`).  This is useful if the
            NFS server is behind a firewall.
          '';
        };

        statdPort = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 4000;
          description = lib.mdDoc ''
            Use a fixed port for {command}`rpc.statd`. This is
            useful if the NFS server is behind a firewall.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.rpcbind.enable = true;

    boot.supportedFilesystems = [ "nfs" ]; # needed for statd and idmapd

    environment.etc.exports.source = exports;

    systemd.services.nfs-server =
      { enable = true;
        wantedBy = [ "multi-user.target" ];

        preStart =
          ''
            mkdir -p /var/lib/nfs/v4recovery
          '';
      };

    systemd.services.nfs-mountd =
      { enable = true;
        restartTriggers = [ exports ];

        preStart =
          ''
            mkdir -p /var/lib/nfs

            ${optionalString cfg.createMountPoints
              ''
                # create export directories:
                # skip comments, take first col which may either be a quoted
                # "foo bar" or just foo (-> man export)
                sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
                | xargs -d '\n' mkdir -p
              ''
            }
          '';
      };

  };

}
