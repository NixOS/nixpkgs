{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mediamtx;
  format = pkgs.formats.yaml { };
in
{
  meta.maintainers = with lib.maintainers; [ fpletz ];

  options = {
    services.mediamtx = {
      enable = lib.mkEnableOption "MediaMTX";

      package = lib.mkPackageOption pkgs "mediamtx" { };

      settings = lib.mkOption {
        description = ''
          Settings for MediaMTX. Refer to the defaults at
          <https://github.com/bluenviron/mediamtx/blob/main/mediamtx.yml>.
        '';
        type = format.type;
        default = { };
        example = {
          paths = {
            cam = {
              runOnInit = "\${lib.getExe pkgs.ffmpeg} -f v4l2 -i /dev/video0 -f rtsp rtsp://localhost:$RTSP_PORT/$RTSP_PATH";
              runOnInitRestart = true;
            };
          };
        };
      };

      env = lib.mkOption {
        type = with lib.types; attrsOf anything;
        description = "Extra environment variables for MediaMTX";
        default = { };
        example = {
          MTX_CONFKEY = "mykey";
        };
      };

      allowVideoAccess = lib.mkEnableOption ''
        access to video devices like cameras on the system
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # NOTE: mediamtx watches this file and automatically reloads if it changes
    environment.etc."mediamtx.yaml".source = format.generate "mediamtx.yaml" cfg.settings;

    systemd.services.mediamtx = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.env;

      serviceConfig = {
        DynamicUser = true;
        User = "mediamtx";
        Group = "mediamtx";
        SupplementaryGroups = lib.mkIf cfg.allowVideoAccess "video";
        ExecStart = "${cfg.package}/bin/mediamtx /etc/mediamtx.yaml";
        Restart = "on-failure";
      };
    };
  };
}
