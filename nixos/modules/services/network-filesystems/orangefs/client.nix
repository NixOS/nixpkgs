{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.orangefs.client;

in
{
  ###### interface

  options = {
    services.orangefs.client = {
      enable = mkEnableOption "OrangeFS client daemon";

      extraOptions = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "Extra command line options for pvfs2-client.";
      };

      fileSystems = mkOption {
        description = ''
          The orangefs file systems to be mounted.
          This option is preferred over using {option}`fileSystems` directly since
          the pvfs client service needs to be running for it to be mounted.
        '';

        example = [
          {
            mountPoint = "/orangefs";
            target = "tcp://server:3334/orangefs";
          }
        ];

        type =
          with types;
          listOf (
            submodule (
              { ... }:
              {
                options = {

                  mountPoint = mkOption {
                    type = types.str;
                    default = "/orangefs";
                    description = "Mount point.";
                  };

                  options = mkOption {
                    type = with types; listOf str;
                    default = [ ];
                    description = "Mount options";
                  };

                  target = mkOption {
                    type = types.str;
                    example = "tcp://server:3334/orangefs";
                    description = "Target URL";
                  };
                };
              }
            )
          );
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.orangefs ];

    boot.supportedFilesystems = [ "pvfs2" ];
    boot.kernelModules = [ "orangefs" ];

    systemd.services.orangefs-client = {
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";

        ExecStart = ''
          ${pkgs.orangefs}/bin/pvfs2-client-core \
             --logtype=syslog ${concatStringsSep " " cfg.extraOptions}
        '';

        TimeoutStopSec = "120";
      };
    };

    systemd.mounts = map (fs: {
      requires = [ "orangefs-client.service" ];
      after = [ "orangefs-client.service" ];
      bindsTo = [ "orangefs-client.service" ];
      wantedBy = [ "remote-fs.target" ];
      type = "pvfs2";
      options = concatStringsSep "," fs.options;
      what = fs.target;
      where = fs.mountPoint;
    }) cfg.fileSystems;
  };
}
