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
    kernelModule = {
      inInitrd = lib.mkEnableOption ''
        installing the `amdgpu` kernelModule into the initrd; making it
        available in stage 1 of the boot process.

        This allows for an earlier modeset to apply the preferred resolution in
        the beginning of the initramfs phase rather than after it.
      '';
    };
    opencl.enable = lib.mkEnableOption ''OpenCL support using ROCM runtime library'';
    # cfg.amdvlk option is defined in ./amdvlk.nix module
  };

  imports = [
    # This can be removed post 24.11; it was only ever in unstable
    (lib.mkRenamedOptionModule [ "hardware" "amdgpu" "initrd" "enable" ] [ "hardware" "amdgpu" "kernelModule" "inInitrd" ])
  ];

  config = {
    boot.kernelParams = lib.optionals cfg.legacySupport.enable [
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "radeon.cik_support=0"
    ];

    boot.initrd.kernelModules = lib.optionals cfg.kernelModule.inInitrd [ "amdgpu" ];

    hardware.opengl = lib.mkIf cfg.opencl.enable {
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
