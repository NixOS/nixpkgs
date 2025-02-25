{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.cpu.intel.npu;
  type.driver =
    with lib.types;
    nullOr (enum [
      "standalone"
      # TODO: "with-compiler"
    ]);
in
{
  options = {
    hardware.cpu.intel.npu = {
      enable = lib.mkEnableOption "Intel NPU support";
      driver = lib.mkOption {
        type = type.driver;
        default = "standalone";
        description = ''
          The driver to use for the Intel NPU.
            - null: Only load the firmware.
            - standalone: Use the standalone driver.

          For more information, see:
          https://github.com/intel/linux-npu-driver/blob/v1.13.0/docs/overview.md
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { hardware.firmware = [ pkgs.intel-npu-firmware ]; }
      (lib.mkIf (cfg.driver == "standalone") {
        environment.systemPackages = [
          pkgs.intel-npu-driver-standalone
          pkgs.intel-npu-driver-standalone.level-zero
        ];
        environment.sessionVariables.LD_LIBRARY_PATH = [
          "${pkgs.intel-npu-driver-standalone}/lib"
          "${pkgs.intel-npu-driver-standalone.level-zero}/lib"
        ];
      })
    ]
  );
}
