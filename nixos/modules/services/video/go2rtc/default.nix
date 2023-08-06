{ lib
, config
, options
, pkgs
, ...
}:

let
  inherit (lib)
    literalExpression
    mdDoc
    mkEnableOption
    mkOption
    mkPackageOptionMD
    types
    ;

  cfg = config.services.go2rtc;
  opt = options.services.go2rtc;

  format = pkgs.formats.yaml {};
  configFile = format.generate "go2rtc.yaml" cfg.settings;
in

{
  meta.buildDocsInSandbox = false;

  options.services.go2rtc = with types; {
    enable = mkEnableOption (mdDoc "go2rtc streaming server");

    package = mkPackageOptionMD pkgs "go2rtc" { };

    settings = mkOption {
      default = {};
      description = mdDoc ''
        go2rtc configuration as a Nix attribute set.

        See the [wiki](https://github.com/AlexxIT/go2rtc/wiki/Configuration) for possible configuration options.
      '';
      type = submodule {
        freeformType = format.type;
        options = {
          # https://github.com/AlexxIT/go2rtc/blob/v1.5.0/README.md#module-api
          api = {
            listen = mkOption {
              type = str;
              default = ":1984";
              example = "127.0.0.1:1984";
              description = mdDoc ''
                API listen address, conforming to a Go address string.
              '';
            };
          };

          # https://github.com/AlexxIT/go2rtc/blob/v1.5.0/README.md#source-ffmpeg
          ffmpeg = {
            bin = mkOption {
              type = path;
              default = "${lib.getBin pkgs.ffmpeg_6-headless}/bin/ffmpeg";
              defaultText = literalExpression "\${lib.getBin pkgs.ffmpeg_6-headless}/bin/ffmpeg";
              description = mdDoc ''
                The ffmpeg package to use for transcoding.
              '';
            };
          };

          # TODO: https://github.com/AlexxIT/go2rtc/blob/v1.5.0/README.md#module-rtsp
          rtsp = {
          };

          streams = mkOption {
            type = attrsOf (either str (listOf str));
            default = {};
            example = literalExpression ''
              {
                cam1 = "onvif://admin:password@192.168.1.123:2020";
                cam2 = "tcp://192.168.1.123:12345";
              }
            '';
            description = mdDoc ''
              Stream source configuration. Multiple source types are supported.

              Check the [configuration reference](https://github.com/AlexxIT/go2rtc/blob/v${cfg.package.version}/README.md#module-streams) for possible options.
            '';
          };

          # TODO: https://github.com/AlexxIT/go2rtc/blob/v1.5.0/README.md#module-webrtc
          webrtc = {
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.go2rtc = {
      after = [
        "network-online.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      serviceConfig = {
        DynamicUser = true;
        User = "go2rtc";
        SupplementaryGroups = [
          # for v4l2 devices
          "video"
        ];
        StateDirectory = "go2rtc";
        ExecStart = "${cfg.package}/bin/go2rtc -config ${configFile}";
      };
    };
  };
}
