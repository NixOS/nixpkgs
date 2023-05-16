{ config, lib, pkgs, ... }:

<<<<<<< HEAD
let
  cfg = config.services.mediamtx;
  format = pkgs.formats.yaml {};
in
{
  meta.maintainers = with lib.maintainers; [ fpletz ];

  options = {
    services.mediamtx = {
      enable = lib.mkEnableOption (lib.mdDoc "MediaMTX");

      package = lib.mkPackageOptionMD pkgs "mediamtx" { };

      settings = lib.mkOption {
        description = lib.mdDoc ''
          Settings for MediaMTX. Refer to the defaults at
          <https://github.com/bluenviron/mediamtx/blob/main/mediamtx.yml>.
        '';
        type = format.type;
        default = {};
        example = {
          paths = {
            cam = {
              runOnInit = "\${lib.getExe pkgs.ffmpeg} -f v4l2 -i /dev/video0 -f rtsp rtsp://localhost:$RTSP_PORT/$RTSP_PATH";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
              runOnInitRestart = true;
            };
          };
        };
      };

<<<<<<< HEAD
      env = lib.mkOption {
        type = with lib.types; attrsOf anything;
=======
      env = mkOption {
        type = with types; attrsOf anything;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        description = lib.mdDoc "Extra environment variables for MediaMTX";
        default = {};
        example = {
          MTX_CONFKEY = "mykey";
        };
      };
<<<<<<< HEAD

      allowVideoAccess = lib.mkEnableOption (lib.mdDoc ''
        Enable access to video devices like cameras on the system.
      '');
    };
  };

  config = lib.mkIf cfg.enable {
=======
    };
  };

  config = mkIf (cfg.enable) {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # NOTE: mediamtx watches this file and automatically reloads if it changes
    environment.etc."mediamtx.yaml".source = format.generate "mediamtx.yaml" cfg.settings;

    systemd.services.mediamtx = {
<<<<<<< HEAD
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.env;
=======
      environment = cfg.env;

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        ffmpeg
      ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      serviceConfig = {
        DynamicUser = true;
        User = "mediamtx";
        Group = "mediamtx";
<<<<<<< HEAD
        SupplementaryGroups = lib.mkIf cfg.allowVideoAccess "video";
        ExecStart = "${cfg.package}/bin/mediamtx /etc/mediamtx.yaml";
=======

        LogsDirectory = "mediamtx";

        # user likely may want to stream cameras, can't hurt to add video group
        SupplementaryGroups = "video";

        ExecStart = "${package}/bin/mediamtx /etc/mediamtx.yaml";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };
}
