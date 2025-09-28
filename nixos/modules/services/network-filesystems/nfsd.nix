{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.nfs.server;

  exports = pkgs.writeText "exports" cfg.exports;

in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "nfs" "lockdPort" ]
      [ "services" "nfs" "server" "lockdPort" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "nfs" "statdPort" ]
      [ "services" "nfs" "server" "statdPort" ]
    )
  ];

  ###### interface

  options = {

    services.nfs = {

      server = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable the kernel's NFS server.
          '';
        };

        extraNfsdConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = ''
            Extra configuration options for the [nfsd] section of /etc/nfs.conf.
          '';
        };

        exports = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Contents of the /etc/exports file.  See
            {manpage}`exports(5)` for the format.
          '';
        };

        hostName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Hostname or address on which NFS requests will be accepted.
            Default is all.  See the {option}`-H` option in
            {manpage}`nfsd(8)`.
          '';
        };

        nproc = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = ''
            Number of NFS server threads.  Defaults to the recommended value of 8.
          '';
        };

        createMountPoints = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to create the mount points in the exports file at startup time.";
        };

        mountdPort = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          example = 4002;
          description = ''
            Use fixed port for rpc.mountd, useful if server is behind firewall.
          '';
        };

        lockdPort = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          example = 4001;
          description = ''
            Use a fixed port for the NFS lock manager kernel module
            (`lockd/nlockmgr`).  This is useful if the
            NFS server is behind a firewall.
          '';
        };

        statdPort = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          example = 4000;
          description = ''
            Use a fixed port for {command}`rpc.statd`. This is
            useful if the NFS server is behind a firewall.
          '';
        };

      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.rpcbind.enable = true;

    boot.supportedFilesystems = [ "nfs" ]; # needed for statd and idmapd

    environment.etc.exports.source = exports;

    systemd.services.nfs-server = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p /var/lib/nfs/v4recovery
      '';
    };

    systemd.services.nfs-mountd = {
      enable = true;
      restartTriggers = [ exports ];

      preStart = ''
        mkdir -p /var/lib/nfs

        ${lib.optionalString cfg.createMountPoints ''
          # create export directories:
          # skip comments, take first col which may either be a quoted
          # "foo bar" or just foo (-> man export)
          sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
          | xargs -d '\n' mkdir -p
        ''}
      '';
    };

  };

}
