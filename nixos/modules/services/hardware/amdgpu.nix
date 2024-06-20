{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.amdgpu;
in {
  options.hardware.amdgpu = {
    legacySupport.enable = lib.mkEnableOption ''
      using `amdgpu` kernel driver instead of `radeon` for Southern Islands
      (Radeon HD 7000) series and Sea Islands (Radeon HD 8000)
      series cards. Note: this removes support for analog video outputs,
      which is only available in the `radeon` driver
    '';
    enable = lib.mkEnableOption "AMD GPU";
    initrd.enable = lib.mkOption {
      description = ''
        Enable loading `amdgpu` kernelModule in stage 1.
        Can fix lower resolution in boot screen during initramfs phase
      '';
      type = lib.types.bool;
      default = cfg.enable;
      defaultText = "hardware.amdgpu.enable";
    };
    opencl.enable = lib.mkOption {
      description = "Enable OpenCL support using Rusticl runtime library.";
      type = lib.types.bool;
      default = cfg.enable;
      defaultText = "hardware.amdgpu.enable";
    };
    opencl.runtime = lib.mkOption {
      description = "Enable OpenCL support using Rusticl runtime library.";
      type = lib.types.enum [ "rusticl" "rocm" ];
      default = "rusticl";
    };
    # cfg.amdvlk option is defined in ./amdvlk.nix module
  };

  config = {
    boot.kernelParams = lib.optionals cfg.legacySupport.enable [
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "radeon.cik_support=0"
    ];

    boot.initrd.kernelModules = lib.optionals cfg.initrd.enable [ "amdgpu" ];

    hardware.opengl = lib.mkIf cfg.opencl.enable {
      enable = lib.mkDefault true;
      extraPackages = if cfg.runtime == "rusticl" then [
        pkgs.mesa.opencl
      ] else [
        pkgs.rocmPackages.clr
        pkgs.rocmPackages.clr.icd
      ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
