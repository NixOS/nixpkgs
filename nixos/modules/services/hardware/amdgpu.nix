{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.amdgpu;
in
{
  options.hardware.amdgpu = {
    legacySupport.enable = lib.mkEnableOption ''
      using `amdgpu` kernel driver instead of `radeon` for Southern Islands
      (Radeon HD 7000) series and Sea Islands (Radeon HD 8000)
      series cards. Note: this removes support for analog video outputs,
      which is only available in the `radeon` driver
    '';

    initrd.enable = lib.mkEnableOption ''
      loading `amdgpu` kernelModule in stage 1.
      Can fix lower resolution in boot screen during initramfs phase
    '';

    overdrive = {
      enable = lib.mkEnableOption ''`amdgpu` overdrive mode for overclocking'';

      ppfeaturemask = lib.mkOption {
        type = lib.types.str;
        default = "0xfffd7fff";
        example = "0xffffffff";
        description = ''
          Sets the `amdgpu.ppfeaturemask` kernel option. It can be used to enable the overdrive bit.
          Default is `0xfffd7fff` as it is less likely to cause flicker issues. Setting it to
          `0xffffffff` enables all features, but also can be unstable. See
          [the kernel documentation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd/include/amd_shared.h#n169)
          for more information.
        '';
      };
    };

    opencl.enable = lib.mkEnableOption ''OpenCL support using ROCM runtime library'';
  };

  config = {
    boot.kernelParams =
      lib.optionals cfg.legacySupport.enable [
        "amdgpu.si_support=1"
        "amdgpu.cik_support=1"
        "radeon.si_support=0"
        "radeon.cik_support=0"
      ]
      ++ lib.optionals cfg.overdrive.enable [
        "amdgpu.ppfeaturemask=${cfg.overdrive.ppfeaturemask}"
      ];

    boot.initrd.kernelModules = lib.optionals cfg.initrd.enable [ "amdgpu" ];

    hardware.graphics = lib.mkIf cfg.opencl.enable {
      enable = lib.mkDefault true;
      extraPackages = [
        pkgs.rocmPackages.clr
        pkgs.rocmPackages.clr.icd
      ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
