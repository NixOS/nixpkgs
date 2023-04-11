{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mediamtx;
  package = pkgs.mediamtx;
  format = pkgs.formats.yaml {};
in
{
  options = {
    services.mediamtx = {
      enable = mkEnableOption (lib.mdDoc "MediaMTX");

      settings = mkOption {
        description = lib.mdDoc ''
          Settings for MediaMTX.
          Read more at <https://github.com/aler9/mediamtx/blob/main/mediamtx.yml>
        '';
        type = format.type;

        default = {
          logLevel = "info";
          logDestinations = [
            "stdout"
          ];
          # we set this so when the user uses it, it just works (see LogsDirectory below). but it's not used by default.
          logFile = "/var/log/mediamtx/mediamtx.log";
        };

        example = {
          paths = {
            cam = {
              runOnInit = "ffmpeg -f v4l2 -i /dev/video0 -f rtsp rtsp://localhost:$RTSP_PORT/$RTSP_PATH";
              runOnInitRestart = true;
            };
          };
        };
      };

      env = mkOption {
        type = with types; attrsOf anything;
        description = lib.mdDoc "Extra environment variables for MediaMTX";
        default = {};
        example = {
          MTX_CONFKEY = "mykey";
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    # NOTE: mediamtx watches this file and automatically reloads if it changes
    environment.etc."mediamtx.yaml".source = format.generate "mediamtx.yaml" cfg.settings;

    systemd.services.mediamtx = {
      environment = cfg.env;

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        ffmpeg
      ];

      serviceConfig = {
        DynamicUser = true;
        User = "mediamtx";
        Group = "mediamtx";

        LogsDirectory = "mediamtx";

        # user likely may want to stream cameras, can't hurt to add video group
        SupplementaryGroups = "video";

        ExecStart = "${package}/bin/mediamtx /etc/mediamtx.yaml";
      };
    };
  };
}
