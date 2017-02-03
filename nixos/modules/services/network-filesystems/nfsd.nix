{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nfs.server;

  exports = pkgs.writeText "exports" cfg.exports;

in

{

  ###### interface

  options = {

    services.nfs = {

      server = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable the kernel's NFS server.
          '';
        };

        exports = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Contents of the /etc/exports file.  See
            <citerefentry><refentrytitle>exports</refentrytitle>
            <manvolnum>5</manvolnum></citerefentry> for the format.
          '';
        };

        hostName = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Hostname or address on which NFS requests will be accepted.
            Default is all.  See the <option>-H</option> option in
            <citerefentry><refentrytitle>nfsd</refentrytitle>
            <manvolnum>8</manvolnum></citerefentry>.
          '';
        };

        nproc = mkOption {
          type = types.int;
          default = 8;
          description = ''
            Number of NFS server threads.  Defaults to the recommended value of 8.
          '';
        };

        createMountPoints = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to create the mount points in the exports file at startup time.";
        };

        mountdPort = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 4002;
          description = ''
            Use fixed port for rpc.mountd, useful if server is behind firewall.
          '';
        };

        lockdPort = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 4001;
          description = ''
            Use a fixed port for the NFS lock manager kernel module
            (<literal>lockd/nlockmgr</literal>).  This is useful if the
            NFS server is behind a firewall.
          '';
        };

        statdPort = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 4000;
          description = ''
            Use a fixed port for <command>rpc.statd</command>. This is
            useful if the NFS server is behind a firewall.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.nfs.extraConfig = ''
      [nfsd]
      threads=${toString cfg.nproc}
      ${optionalString (cfg.hostName != null) "host=${cfg.hostName}"}

      [mountd]
      ${optionalString (cfg.mountdPort != null) "port=${toString cfg.mountdPort}"}

      [statd]
      ${optionalString (cfg.statdPort != null) "port=${toString cfg.statdPort}"}

      [lockd]
      ${optionalString (cfg.lockdPort != null) ''
        port=${toString cfg.lockdPort}
        udp-port=${toString cfg.lockdPort}
      ''}
    '';

    services.rpcbind.enable = true;

    boot.supportedFilesystems = [ "nfs" ]; # needed for statd and idmapd

    environment.etc.exports.source = exports;

    systemd.services.nfs-server =
      { enable = true;
        wantedBy = [ "multi-user.target" ];
      };

    systemd.services.nfs-mountd =
      { enable = true;
        path = [ pkgs.nfs-utils ];
        restartTriggers = [ exports ];

        preStart =
          ''
            ${optionalString cfg.createMountPoints
              ''
                # create export directories:
                # skip comments, take first col which may either be a quoted
                # "foo bar" or just foo (-> man export)
                sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
                | xargs -d '\n' mkdir -p
              ''
            }

            exportfs -rav
          '';
      };

  };

}
