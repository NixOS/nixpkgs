{ config, lib, pkgs, ... }:

let
  inherit (lib)
    optionalAttrs optionalString recursiveUpdate
    mkEnableOption mkOption mkIf types mkRenamedOptionModule mkRemovedOptionModule;

  cfg = config.services.nfs.server;

  exports = pkgs.writeText "exports" cfg.exports;

  format = pkgs.formats.ini { };

  libDir = "/var/lib/nfs";

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "nfs" "server" "extraNfsdConfig" ] "RFC42 compliant settings in services.nfs.server.settings")
    (mkRenamedOptionModule [ "services" "nfs" "lockdPort" ] [ "services" "nfs" "server" "lockdPort" ])
    (mkRenamedOptionModule [ "services" "nfs" "statdPort" ] [ "services" "nfs" "server" "statdPort" ])
  ];

  ###### interface

  options.services.nfs.server = {
    enable = mkEnableOption "the kernel's NFS server";

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Extra configuration options for /etc/nfs.conf.

        See <citerefentry><refentrytitle>nfs.conf</refentrytitle><manvolnum>5</manvolnum></citerefentry>
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


  ###### implementation

  config = mkIf cfg.enable {

    services = {
      nfs.settings = recursiveUpdate
        {
          nfsd = { threads = cfg.nproc; }
            // optionalAttrs (cfg.hostName != null) { host = cfg.hostName; };
          mountd = { }
            // optionalAttrs (cfg.mountdPort != null) { port = cfg.mountdPort; };
          statd = { }
            // optionalAttrs (cfg.statdPort != null) { port = cfg.statdPort; };
          lockd = { }
            // optionalAttrs (cfg.lockdPort != null) {
            port = cfg.lockdPort;
            udp-port = cfg.lockdPort;
          };
        }
        cfg.settings;

      rpcbind.enable = true;
    };

    boot.supportedFilesystems = [ "nfs" ]; # needed for statd and idmapd

    environment.etc.exports.source = exports;

    systemd = {
      services = {
        nfs-server = {
          enable = true;
          wantedBy = [ "multi-user.target" ];
        };

        nfs-mountd = {
          enable = true;
          restartTriggers = [ exports ];

          preStart = optionalString cfg.createMountPoints ''
            # create export directories:
            # skip comments, take first col which may either be a quoted
            # "foo bar" or just foo (-> man export)
            sed '/^#.*/d;s/^"\([^"]*\)".*/\1/;t;s/[ ].*//' ${exports} \
            | xargs -d '\n' mkdir -p
          '';
        };

        nfsdcld.serviceConfig = {
          Type = "exec";
          ExecStart = [ "" "${pkgs.nfs-utils}/bin/nfsdcld --foreground" ];
        };
      };

      tmpfiles.rules = [
        "d ${libDir}            0755 - - - -"
        "d ${libDir}/nfsdcld    0775 root nogroup - -"
        "d ${libDir}/v4recovery 0755 - - - -"
      ];
    };
  };
}
