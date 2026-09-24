{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.interception-tools;
in
{
  options.services.interception-tools = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the interception tools service.";
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.interception-tools-plugins.caps2esc ];
      defaultText = lib.literalExpression "[ pkgs.interception-tools-plugins.caps2esc ]";
      description = ''
        A list of interception tools plugins that will be made available to use
        inside the udevmon configuration.
      '';
    };

    udevmonConfig = lib.mkOption {
      type = lib.types.either lib.types.str lib.types.path;
      default = ''
        - JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
      example = ''
        - JOB: "intercept -g $DEVNODE | y2z | x2y | uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_X, KEY_Y]
      '';
      description = ''
        String of udevmon YAML configuration, or path to a udevmon YAML
        configuration file.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.interception-tools = {
      description = "Interception tools";
      path = [
        pkgs.bash
        pkgs.interception-tools
      ]
      ++ cfg.plugins;
      serviceConfig = {
        ExecStart = ''
          ${pkgs.interception-tools}/bin/udevmon -c \
          ${
            if builtins.typeOf cfg.udevmonConfig == "path" then
              cfg.udevmonConfig
            else
              pkgs.writeText "udevmon.yaml" cfg.udevmonConfig
          }
        '';
        Nice = -20;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
