{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.gnunet;

  homeDir = "/var/lib/gnunet";

  configFile = with cfg; pkgs.writeText "gnunetd.conf"
    ''
      [PATHS]
      SERVICEHOME = ${homeDir}

      [ats]
      WAN_QUOTA_IN = ${toString load.maxNetDownBandwidth} b
      WAN_QUOTA_OUT = ${toString load.maxNetUpBandwidth} b

      [datastore]
      QUOTA = ${toString fileSharing.quota} MB

      [transport-udp]
      PORT = ${toString udp.port}
      ADVERTISED_PORT = ${toString udp.port}

      [transport-tcp]
      PORT = ${toString tcp.port}
      ADVERTISED_PORT = ${toString tcp.port}

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

      fileSharing = {
        quota = mkOption {
          default = 1024;
          description = ''
            Maximum file system usage (in MiB) for file sharing.
          '';
        };
      };

      udp = {
        port = mkOption {
          default = 2086;  # assigned by IANA
          description = ''
            The UDP port for use by GNUnet.
          '';
        };
      };

      tcp = {
        port = mkOption {
          default = 2086;  # assigned by IANA
          description = ''
            The TCP port for use by GNUnet.
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
      };

      extraOptions = mkOption {
        default = "";
        description = ''
          Additional options that will be copied verbatim in `gnunet.conf'.
          See `gnunet.conf(5)' for details.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.gnunet.enable {

    users.extraUsers.gnunet = {
      group = "gnunet";
      description = "GNUnet User";
      home = homeDir;
      createHome = true; 
      uid = config.ids.uids.gnunet;
    };

    users.extraGroups.gnunet.gid = config.ids.gids.gnunet;

    # The user tools that talk to `gnunetd' should come from the same source,
    # so install them globally.
    environment.systemPackages = [ pkgs.gnunet ];

    systemd.services.gnunet = {
      description = "GNUnet";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.gnunet pkgs.miniupnpc ];
      serviceConfig.ExecStart = "${pkgs.gnunet}/lib/gnunet/libexec/gnunet-service-arm -c ${configFile}";
      serviceConfig.User = "gnunet";
      serviceConfig.UMask = "0007";
      serviceConfig.WorkingDirectory = homeDir;
    };

  };

}
