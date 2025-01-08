{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.v4l2-relayd;

  kernelPackages = config.boot.kernelPackages;

  gst = (
    with pkgs.gst_all_1;
    [
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gstreamer.out
    ]
  );

  instanceOpts =
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "this v4l2-relayd instance";

        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = ''
            The name of the instance.
          '';
        };

        cardLabel = lib.mkOption {
          type = lib.types.str;
          description = ''
            The name the camera will show up as.
          '';
        };

        extraPackages = lib.mkOption {
          type = with lib.types; listOf package;
          default = [ ];
          description = ''
            Extra packages to add to {env}`GST_PLUGIN_PATH` for the instance.
          '';
        };

        input = {
          pipeline = lib.mkOption {
            type = lib.types.str;
            description = ''
              The gstreamer-pipeline to use for the input-stream.
            '';
          };

          format = lib.mkOption {
            type = lib.types.str;
            default = "YUY2";
            description = ''
              The video-format to read from input-stream.
            '';
          };

          width = lib.mkOption {
            type = lib.types.ints.positive;
            default = 1280;
            description = ''
              The width to read from input-stream.
            '';
          };

          height = lib.mkOption {
            type = lib.types.ints.positive;
            default = 720;
            description = ''
              The height to read from input-stream.
            '';
          };

          framerate = lib.mkOption {
            type = lib.types.ints.positive;
            default = 30;
            description = ''
              The framerate to read from input-stream.
            '';
          };
        };

        output = {
          format = lib.mkOption {
            type = lib.types.str;
            default = "YUY2";
            description = ''
              The video-format to write to output-stream.
            '';
          };
        };

      };
    };

in
{

  options.services.v4l2-relayd = {

    instances = lib.mkOption {
      type = with lib.types; attrsOf (submodule instanceOpts);
      default = { };
      example = lib.literalExpression ''
        {
          example = {
            cardLabel = "Example card";
            input.pipeline = "videotestsrc";
          };
        }
      '';
      description = ''
        v4l2-relayd instances to be created.
      '';
    };

  };

  config =
    let

      mkInstanceService = instance: {
        description = "Streaming relay for v4l2loopback using GStreamer";

        after = [
          "modprobe@v4l2loopback.service"
          "systemd-logind.service"
        ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "always";
          PrivateNetwork = true;
          PrivateTmp = true;
          LimitNPROC = 1;
        };

        environment = {
          GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (gst ++ instance.extraPackages);
          V4L2_DEVICE_FILE = "/run/v4l2-relayd-${instance.name}/device";
        };

        script =
          let
            appsrcOptions = lib.concatStringsSep "," [
              "caps=video/x-raw"
              "format=${instance.input.format}"
              "width=${toString instance.input.width}"
              "height=${toString instance.input.height}"
              "framerate=${toString instance.input.framerate}/1"
            ];

            outputPipeline =
              [
                "appsrc name=appsrc ${appsrcOptions}"
                "videoconvert"
              ]
              ++ lib.optionals (instance.input.format != instance.output.format) [
                "video/x-raw,format=${instance.output.format}"
                "queue"
              ]
              ++ [ "v4l2sink name=v4l2sink device=$(cat $V4L2_DEVICE_FILE)" ];
          in
          ''
            exec ${pkgs.v4l2-relayd}/bin/v4l2-relayd -i "${instance.input.pipeline}" -o "${lib.concatStringsSep " ! " outputPipeline}"
          '';

        preStart = ''
          mkdir -p $(dirname $V4L2_DEVICE_FILE)
          ${kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl add -x 1 -n "${instance.cardLabel}" > $V4L2_DEVICE_FILE
        '';

        postStop = ''
          ${kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl delete $(cat $V4L2_DEVICE_FILE)
          rm -rf $(dirname $V4L2_DEVICE_FILE)
        '';
      };

      mkInstanceServices =
        instances:
        lib.listToAttrs (
          map (
            instance:
            lib.nameValuePair "v4l2-relayd-${utils.escapeSystemdPath instance.name}" (mkInstanceService instance)
          ) instances
        );

      enabledInstances = lib.attrValues (lib.filterAttrs (n: v: v.enable) cfg.instances);

    in
    {

      boot = lib.mkIf ((lib.length enabledInstances) > 0) {
        extraModulePackages = [ kernelPackages.v4l2loopback ];
        kernelModules = [ "v4l2loopback" ];
      };

      systemd.services = mkInstanceServices enabledInstances;

    };

  meta.maintainers = with lib.maintainers; [ betaboon ];
}
