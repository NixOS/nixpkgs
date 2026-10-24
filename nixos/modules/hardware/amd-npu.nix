{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    ;

  cfg = config.hardware.amd-npu;
in
{
  options.hardware.amd-npu = {
    enable = mkEnableOption "AMD Ryzen AI NPU (XDNA), the in-kernel amdxdna driver and XRT userspace";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.xrt.xdna;
      defaultText = lib.literalExpression "pkgs.xrt.xdna";
      description = ''
        XRT package with the AMD XDNA plugin to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.14";
        message = "hardware.amd-npu requires kernel 6.14 or later for the in-tree amdxdna driver.";
      }
    ];

    boot.kernelModules = [ "amdxdna" ];

    environment.systemPackages = [ cfg.package ];

    services.udev.extraRules = ''
      KERNEL=="accel*", SUBSYSTEM=="misc", ATTRS{driver}=="amdxdna", GROUP="video", MODE="0660"
    '';

    security.pam.loginLimits = [
      {
        domain = "@video";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
    ];
  };
}
