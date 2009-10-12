{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.gnunet;

  configFile = with cfg; pkgs.writeText "gnunetd.conf"
    ''
      [PATHS]
      GNUNETD_HOME = ${home}

      [GNUNETD]
      HOSTLISTURL = ${lib.concatStringsSep " " hostLists}
      APPLICATIONS = ${lib.concatStringsSep " " applications}
      TRANSPORTS = ${lib.concatStringsSep " " transports}

      [LOAD]
      MAXNETDOWNBPSTOTAL = ${toString load.maxNetDownBandwidth}
      MAXNETUPBPSTOTAL = ${toString load.maxNetUpBandwidth}
      HARDUPLIMIT = ${toString load.hardNetUpBandwidth}
      MAXCPULOAD = ${toString load.maxCPULoad}
      INTERFACES = ${lib.concatStringsSep " " load.interfaces}

      [FS]
      QUOTA = ${toString fileSharing.quota}
      ACTIVEMIGRATION = ${if fileSharing.activeMigration then "YES" else "NO"}

      [MODULES]
      sqstore = sqstore_sqlite
      dstore = dstore_sqlite
      topology = topology_default

      ${extraOptions}
    '';

in

{

  ###### interface

  options = {
  
    services.gnunet = {
      
      enable = mkOption {
        default = false;
        description = ''
          Whether to run the GNUnet daemon.  GNUnet is GNU's anonymous
          peer-to-peer communication and file sharing framework.
        '';
      };

      home = mkOption {
        default = "/var/lib/gnunet";
        description = ''
          Directory where the GNUnet daemon will store its data.
        '';
      };

      debug = mkOption {
        default = false;
        description = ''
          When true, run in debug mode; gnunetd will not daemonize and
          error messages will be written to stderr instead of a
          logfile.
        '';
      };

      logLevel = mkOption {
        default = "ERROR";
        example = "INFO";
        description = ''
          Log level of the deamon (see `gnunetd(1)' for details).
        '';
      };

      hostLists = mkOption {
        default = [
          "http://gnunet.org/hostlist.php"
          "http://gnunet.mine.nu:8081/hostlist"
          "http://vserver1236.vserver-on.de/hostlist-074"
        ];
        description = ''
          URLs of host lists.
        '';
      };

      applications = mkOption {
        default = [ "advertising" "getoption" "fs" "stats" "traffic" ];
        example = [ "chat" "fs" ];
        description = ''
          List of GNUnet applications supported by the daemon.  Note that
          `fs', which means "file sharing", is probably the one you want.
        '';
      };

      transports = mkOption {
        default = [ "udp" "tcp" "http" "nat" ];
        example = [ "smtp" "http" ];
        description = ''
          List of transport methods used by the server.
        '';
      };

      fileSharing = {
        quota = mkOption {
          default = 1024;
          description = ''
            Maximum file system usage (in MiB) for file sharing.
          '';
        };

        activeMigration = mkOption {
          default = false;
          description = ''
            Whether to allow active migration of content originating
            from other nodes.
          '';
        };
      };

      load = {
        maxNetDownBandwidth = mkOption {
          default = 50000;
          description = ''
            Maximum bandwidth usage (in bits per second) for GNUnet
            when downloading data.
          '';
        };

        maxNetUpBandwidth = mkOption {
          default = 50000;
          description = ''
            Maximum bandwidth usage (in bits per second) for GNUnet
            when downloading data.
          '';
        };

        hardNetUpBandwidth = mkOption {
          default = 0;
          description = ''
            Hard bandwidth limit (in bits per second) when uploading
            data.
          '';
        };

        maxCPULoad = mkOption {
          default = 100;
          description = ''
            Maximum CPU load (percentage) authorized for the GNUnet
            daemon.
          '';
        };

        interfaces = mkOption {
          default = [ "eth0" ];
          example = [ "wlan0" "eth1" ];
          description = ''
            List of network interfaces to use.
          '';
        };
      };

      extraOptions = mkOption {
        default = "";
        example = ''
          [NETWORK]
          INTERFACE = eth3
        '';
        description = ''
          Additional options that will be copied verbatim in `gnunetd.conf'.
          See `gnunetd.conf(5)' for details.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.gnunet.enable {

    users.extraUsers = singleton
      { name = "gnunetd";
        uid = config.ids.uids.gnunetd;
        description = "GNUnet Daemon User";
        home = "/var/empty";
      };

    jobAttrs.gnunetd =
      { description = "The GNUnet Daemon";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        preStart =
          ''
            test -d "${cfg.home}" || \
              ( mkdir -m 755 -p "${cfg.home}" && chown -R gnunetd:users "${cfg.home}")
          '';

        exec =
          ''
            respawn ${pkgs.gnunet}/bin/gnunetd              \
              ${if debug then "--debug" else "" }           \
              --user="gnunetd"                              \
              --config="${configFile}"                      \
              --log="${cfg.logLevel}"
          '';
      };

  };

}
