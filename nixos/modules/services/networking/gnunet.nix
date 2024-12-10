{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.gnunet;

  stateDir = "/var/lib/gnunet";

  configFile = with cfg; ''
    [PATHS]
    GNUNET_HOME = ${stateDir}
    GNUNET_RUNTIME_DIR = /run/gnunet
    GNUNET_USER_RUNTIME_DIR = /run/gnunet
    GNUNET_DATA_HOME = ${stateDir}/data

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
        type = types.bool;
        default = false;
        description = ''
          Whether to run the GNUnet daemon.  GNUnet is GNU's anonymous
          peer-to-peer communication and file sharing framework.
        '';
      };

      fileSharing = {
        quota = mkOption {
          type = types.int;
          default = 1024;
          description = ''
            Maximum file system usage (in MiB) for file sharing.
          '';
        };
      };

      udp = {
        port = mkOption {
          type = types.port;
          default = 2086; # assigned by IANA
          description = ''
            The UDP port for use by GNUnet.
          '';
        };
      };

      tcp = {
        port = mkOption {
          type = types.port;
          default = 2086; # assigned by IANA
          description = ''
            The TCP port for use by GNUnet.
          '';
        };
      };

      load = {
        maxNetDownBandwidth = mkOption {
          type = types.int;
          default = 50000;
          description = ''
            Maximum bandwidth usage (in bits per second) for GNUnet
            when downloading data.
          '';
        };

        maxNetUpBandwidth = mkOption {
          type = types.int;
          default = 50000;
          description = ''
            Maximum bandwidth usage (in bits per second) for GNUnet
            when downloading data.
          '';
        };

        hardNetUpBandwidth = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Hard bandwidth limit (in bits per second) when uploading
            data.
          '';
        };
      };

      package = mkPackageOption pkgs "gnunet" {
        example = "gnunet_git";
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional options that will be copied verbatim in `gnunet.conf`.
          See {manpage}`gnunet.conf(5)` for details.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf config.services.gnunet.enable {

    users.users.gnunet = {
      group = "gnunet";
      description = "GNUnet User";
      uid = config.ids.uids.gnunet;
    };

    users.groups.gnunet.gid = config.ids.gids.gnunet;

    # The user tools that talk to `gnunetd' should come from the same source,
    # so install them globally.
    environment.systemPackages = [ cfg.package ];

    environment.etc."gnunet.conf".text = configFile;

    systemd.services.gnunet = {
      description = "GNUnet";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."gnunet.conf".source ];
      path = [
        cfg.package
        pkgs.miniupnpc
      ];
      serviceConfig.ExecStart = "${cfg.package}/lib/gnunet/libexec/gnunet-service-arm -c /etc/gnunet.conf";
      serviceConfig.User = "gnunet";
      serviceConfig.UMask = "0007";
      serviceConfig.WorkingDirectory = stateDir;
      serviceConfig.RuntimeDirectory = "gnunet";
      serviceConfig.StateDirectory = "gnunet";
    };

  };

}
