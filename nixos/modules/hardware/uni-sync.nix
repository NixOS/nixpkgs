{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.uni-sync;
in
{
  meta.maintainers = with lib.maintainers; [ yunfachi ];

  options.hardware.uni-sync = {
    enable = lib.mkEnableOption "udev rules and software for Lian Li Uni Controllers";
    package = lib.mkPackageOption pkgs "uni-sync" { };

    devices = lib.mkOption {
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            device_id = "VID:1111/PID:11111/SN:1111111111";
            sync_rgb = true;
            channels = [
              {
                mode = "PWM";
              }
              {
                mode = "Manual";
                speed = 100;
              }
              {
                mode = "Manual";
                speed = 54;
              }
              {
                mode = "Manual";
                speed = 0;
              }
            ];
          }
          {
            device_id = "VID:1010/PID:10101/SN:1010101010";
            sync_rgb = false;
            channels = [
              {
                mode = "Manual";
                speed = 0;
              }
            ];
          }
        ]
      '';
      description = "List of controllers with their configurations.";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            device_id = lib.mkOption {
              type = lib.types.str;
              example = "VID:1111/PID:11111/SN:1111111111";
              description = "Unique device ID displayed at each startup.";
            };
            sync_rgb = lib.mkOption {
              type = lib.types.bool;
              default = false;
              example = true;
              description = "Enable ARGB header sync.";
            };
            channels = lib.mkOption {
              default = [ ];
              example = lib.literalExpression ''
                [
                  {
                    mode = "PWM";
                  }
                  {
                    mode = "Manual";
                    speed = 100;
                  }
                  {
                    mode = "Manual";
                    speed = 54;
                  }
                  {
                    mode = "Manual";
                    speed = 0;
                  }
                ]
              '';
              description = "List of channels connected to the controller.";
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    mode = lib.mkOption {
                      type = lib.types.enum [
                        "Manual"
                        "PWM"
                      ];
                      default = "Manual";
                      example = "PWM";
                      description = "\"PWM\" to enable PWM sync. \"Manual\" to set speed.";
                    };
                    speed = lib.mkOption {
                      type = lib.types.int;
                      default = "50";
                      example = "100";
                      description = "Fan speed as percentage (clamped between 0 and 100).";
                    };
                  };
                }
              );
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."uni-sync/uni-sync.json".text = lib.mkIf (cfg.devices != [ ]) (
      builtins.toJSON { configs = cfg.devices; }
    );

    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
