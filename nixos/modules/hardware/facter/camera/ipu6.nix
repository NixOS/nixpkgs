{ config, lib, ... }:
let
  inherit (config.hardware.facter) report detected;
  facterLib = import ../lib.nix lib;

  isCpuGeneration =
    _family: models:
    facterLib.hasIntelCpu report
    && lib.any (
      actual: (actual.family or 0) == 6 && builtins.elem (actual.model or 0) models
    ) report.hardware.cpu;

  # Family model combinations have been looked up at https://en.wikichip.org/wiki/intel/cpuid
  isTigerLake = isCpuGeneration 6 [
    140 # Combination tested on actual hardware
    141
  ];

  isAdlerLake = isCpuGeneration 6 [
    151
    154
  ];

  isRaptorLake = isCpuGeneration 6 [
    183
    186
    190
    191
  ];

  isMeteorLake = isCpuGeneration 6 [
    170
    171
    172
  ];

  devices = builtins.fromJSON (builtins.readFile ./ipu6-devices.json);
  isCameraSupported =
    let
      default = {
        value = 0;
      };
    in
    lib.any (
      {
        base_class ? default,
        sub_class ? default,
        vendor ? default,
        sub_vendor ? default,
        device ? default,
        sub_device ? default,
        revision ? default,
        bus_type ? {
          name = "";
        },
        ...
      }:
      let
        baseClassHex = facterLib.toZeroPaddedHex base_class.value;
        subClassHex = facterLib.toZeroPaddedHex sub_class.value;
        vendorHex = facterLib.toZeroPaddedHex vendor.value;
        subVendorHex = facterLib.toZeroPaddedHex sub_vendor.value;
        deviceHex = facterLib.toZeroPaddedHex device.value;
        subDeviceHex = facterLib.toZeroPaddedHex sub_device.value;
        revisionHex = facterLib.toZeroPaddedHex revision.value;
      in
      bus_type.name == "PCI"
      && devices
      ? "${vendorHex}:${deviceHex}:${subVendorHex}:${subDeviceHex}/${baseClassHex}-${subClassHex}-${revisionHex}"
    );
in
{
  options.hardware.facter.detected.camera.ipu6.enable =
    let
      cameraSupported =
        isCameraSupported (report.hardware.unknown or [ ])
        || isCameraSupported (report.hardware.pci or [ ]);

      cpuSupported = lib.any (generation: generation) [
        isTigerLake
        isAdlerLake
        isRaptorLake
        isMeteorLake
      ];
    in
    lib.mkEnableOption "webcams using ipu6 from Intel"
    // {
      default = cameraSupported && cpuSupported;
      defaultText = "hardware dependent";
    };

  config.hardware.ipu6 = lib.mkIf detected.camera.ipu6.enable {
    enable = true;
    platform =
      if isTigerLake then
        "ipu6"
      else if isAdlerLake || isRaptorLake then
        "ipu6ep"
      else if isMeteorLake then
        "ipu6epmtl"
      else
        throw "Unexpected CPU generation for ipu6 detected.";
  };

  config.warnings =
    let
      isKernel6_16 = config.boot.kernelPackages.kernel.version == "6.16";
      inherit (detected.camera) ipu6;
    in
    lib.optional (isKernel6_16 && ipu6.enable) ''
      A regression bug can occur when combining ipu6 with kernel version 6.16.
      This will most likely prevent your system from properely suspending or shutting down.
      For more information see: https://github.com/intel/ipu6-drivers/issues/372
    '';
}
