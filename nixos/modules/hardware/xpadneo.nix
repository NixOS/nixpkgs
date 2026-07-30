{ config, lib, ... }:
let
  cfg = config.hardware.xpadneo;

  modprobeConfig =
    let
      params = lib.mapAttrsToList (name: value: "${name}=${toString value}") cfg.settings;
    in
    lib.optionalString (params != [ ]) "options hid_xpadneo ${lib.concatStringsSep " " params}";
in
{
  options.hardware.xpadneo = {
    enable = lib.mkEnableOption "the xpadneo driver for Xbox One wireless controllers";

    rumbleAttenuation = lib.mkOption {
      type = lib.types.submodule {
        options = {
          overall = lib.mkOption {
            type = lib.types.ints.between 0 100;
            default = 0;
            description = ''
              Overall force feedback attenuation as a percentage.
              `0` means full rumble, `100` means no rumble.
              Applies to both main and trigger rumble.
            '';
          };
          triggers = lib.mkOption {
            type = lib.types.nullOr (lib.types.ints.between 0 100);
            default = null;
            description = ''
              Extra attenuation for trigger rumble as a percentage, applied
              on top of {option}`overall`. For example, `overall = 50` and
              `triggers = 50` results in 50% main rumble and 25% trigger rumble.
              Set to `100` to disable trigger rumble while keeping main rumble.
              `null` means no extra trigger attenuation.
            '';
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          overall = 50;   # 50% overall rumble
          triggers = 50;  # 25% trigger rumble (50% of 50%)
        }
      '';
      description = ''
        Force feedback attenuation settings. Higher values reduce rumble strength.

        See <https://github.com/atar-axis/xpadneo/blob/master/docs/CONFIGURATION.md>
        for more information.
      '';
    };

    quirks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.ints.u16);
      default = { };
      example = lib.literalExpression ''
        {
          "11:22:33:44:55:66" = 7; # Applies flags 1 + 2 + 4
        }
      '';
      description = ''
        Controller-specific quirk flags, keyed by MAC address.
        Flags are combined as a bitmask to address compatibility issues
        with specific controllers.

        The value is a sum of individual flag values. For example, to apply
        flags 1, 2, and 4, use `7` (1 + 2 + 4). To apply flags 2, 4, and 32,
        use `38` (2 + 4 + 32).

        See <https://github.com/atar-axis/xpadneo/blob/master/docs/CONFIGURATION.md>
        for available quirk flags and their values.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.int
          lib.types.str
        ]
      );
      default = { };
      example = lib.literalExpression ''
        {
          disable_deadzones = 1;
          trigger_rumble_mode = 2;
          disable_shift_mode = 1;
        }
      '';
      description = ''
        Kernel module parameters for hid_xpadneo. These are passed directly
        to the module via modprobe.

        See <https://github.com/atar-axis/xpadneo/blob/master/docs/CONFIGURATION.md>
        for available parameters and their values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.xpadneo.settings =
      lib.optionalAttrs (cfg.rumbleAttenuation.overall != 0 || cfg.rumbleAttenuation.triggers != null) {
        rumble_attenuation =
          toString cfg.rumbleAttenuation.overall
          + lib.optionalString (cfg.rumbleAttenuation.triggers != null) (
            "," + toString cfg.rumbleAttenuation.triggers
          );
      }
      // lib.optionalAttrs (cfg.quirks != { }) {
        quirks = lib.concatStringsSep "," (
          lib.mapAttrsToList (mac: flags: "${mac}:${toString flags}") cfg.quirks
        );
      };

    boot = {
      extraModprobeConfig = lib.mkMerge [
        # Must disable Enhanced Retransmission Mode to support bluetooth pairing
        # https://wiki.archlinux.org/index.php/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
        (lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "5.12") "options bluetooth disable_ertm=1")
        modprobeConfig
      ];
      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
      kernelModules = [ "hid_xpadneo" ];
    };

    hardware.bluetooth.enable = true;
  };

  meta = {
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
