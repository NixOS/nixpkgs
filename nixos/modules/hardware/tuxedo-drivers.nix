{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.tuxedo-drivers;
  tuxedo-drivers = config.boot.kernelPackages.tuxedo-drivers;
  udevRule =
    attr: val:
    let
      # Workaround to evaluate true to "1" and false to "0".
      # Otherwise, true evaluates to "1" and false to "".
      newVal = if lib.isBool val then (if val then "1" else "0") else val;
    in
    lib.concatStringsSep ", " [
      ''SUBSYSTEM=="platform"''
      ''DRIVER=="tuxedo_keyboard"''
      ''ATTR{${attr}}="${newVal}"''
    ];
  optUdevRule = attr: val: lib.optional (val != null) (udevRule attr val);
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "hardware"
        "tuxedo-keyboard"
      ]
      [
        "hardware"
        "tuxedo-drivers"
      ]
    )
  ];

  options.hardware.tuxedo-drivers = {
    enable = lib.mkEnableOption ''
      The tuxedo-drivers driver enables access to the following on TUXEDO notebooks:
      - Driver for Fn-keys
      - SysFS control of brightness/color/mode for most TUXEDO keyboards
      - Hardware I/O driver for TUXEDO Control Center

      For more inforation it is best to check at the source code description: <https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers>
    '';
    settings = {
      charging-profile = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "high_capacity"
            "balanced"
            "stationary"
          ]
        );
        default = null;
        description = ''
          The maximum charge level to help reduce battery wear:
          - `high_capacity` charges to 100% (driver default)
          - `balanced` charges to 90%
          - `stationary` charges to 80% (maximum lifespan)

          **Note:** Regardless of the configured charging profile, the operating system will always report the battery as being charged to 100%.
        '';
      };
      charging-priority = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "charge_battery"
            "performance"
          ]
        );
        default = null;
        description = ''
          These options manage the trade-off between battery charging and CPU performance when the USB-C power supply cannot provide sufficient power for both simultaneously:
          - `charge_battery` prioritizes battery charging (driver default)
          - `performance` prioritizes maximum CPU performance
        '';
      };
      fn-lock = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Enables or disables the laptop keyboard's Function (Fn) lock at boot.

          When set to `true`, the Fn lock is enabled, allowing the function keys (F1–F12) to control brightness, volume etc.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "tuxedo_keyboard" ];
    boot.extraModulePackages = [ tuxedo-drivers ];
    services.udev.packages = [
      tuxedo-drivers
    ]
    ++ lib.optional (lib.any (v: v != null) (lib.attrValues cfg.settings)) (
      pkgs.writeTextDir "etc/udev/rules.d/90-tuxedo.rules" (
        lib.concatLines (
          [ "# Custom rules for TUXEDO laptops" ]
          ++ (optUdevRule "charging_profile/charging_profile" cfg.settings.charging-profile)
          ++ (optUdevRule "charging_priority/charging_prio" cfg.settings.charging-priority)
          ++ (optUdevRule "fn_lock" cfg.settings.fn-lock)
        )
      )
    );
  };
}
