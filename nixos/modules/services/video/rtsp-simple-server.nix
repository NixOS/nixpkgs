{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rtsp-simple-server;
  package = pkgs.rtsp-simple-server;
  format = pkgs.formats.yaml {};
in
{
  options = {
    services.rtsp-simple-server = {
      enable = mkEnableOption "RTSP Simple Server";

      settings = mkOption {
        description = lib.mdDoc ''
          Settings for rtsp-simple-server.
          Read more at <https://github.com/aler9/rtsp-simple-server/blob/main/rtsp-simple-server.yml>
        '';
        type = format.type;

        default = {
          logLevel = "info";
          logDestinations = [
            "stdout"
          ];
          # we set this so when the user uses it, it just works (see LogsDirectory below). but it's not used by default.
          logFile = "/var/log/rtsp-simple-server/rtsp-simple-server.log";
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
        description = lib.mdDoc "Extra environment variables for RTSP Simple Server";
        default = {};
        example = {
          RTSP_CONFKEY = "mykey";
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    # NOTE: rtsp-simple-server watches this file and automatically reloads if it changes
    environment.etc."rtsp-simple-server.yaml".source = format.generate "rtsp-simple-server.yaml" cfg.settings;

    systemd.services.rtsp-simple-server = {
      environment = cfg.env;

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        ffmpeg
      ];

      serviceConfig = {
        DynamicUser = true;
        User = "rtsp-simple-server";
        Group = "rtsp-simple-server";

        LogsDirectory = "rtsp-simple-server";

        # user likely may want to stream cameras, can't hurt to add video group
        SupplementaryGroups = "video";

        ExecStart = "${package}/bin/rtsp-simple-server /etc/rtsp-simple-server.yaml";
      };
    };
  };
}
