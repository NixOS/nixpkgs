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

    kernelModule = {
      inInitrd = lib.mkEnableOption ''
        installing the `amdgpu` kernelModule into the initrd; making it
        available in stage 1 of the boot process.

        This allows for an earlier modeset to apply the preferred resolution in
        the beginning of the initramfs phase rather than after it.
      '';

      patches = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        description = ''
          Patches to apply to the kernel for the `amdgpu` kernel module build.

          This is intended for applying small patches concerning only the
          `amdgpu` module's internals without needing to rebuild the entire
          kernel.

          The patches are applied to the entire kernel tree but only the
          `amdgpu` module will actually be built and used. You should therefore
          not touch anything outside of `drivers/gpu/drm/amd/amdgpu` using the
          patches as those modifications will not be present in the actual
          kernel you will be running which might cause undefined and likely
          erroneous behaviour.
          Use {option}`boot.kernelPatches` instead for such cases.

          A reboot is required for the patched module to be loaded.
        '';
        example = lib.literalExpression ''
          [
            (pkgs.fetchpatch2 {
              url = "https://lore.kernel.org/lkml/20240610-amdgpu-min-backlight-quirk-v1-1-8459895a5b2a@weissschuh.net/raw";
              hash = "";
            })
          ]
        '';
      };
    };

    opencl.enable = lib.mkEnableOption ''OpenCL support using ROCM runtime library'';
    # cfg.amdvlk option is defined in ./amdvlk.nix module
  };

  imports = [
    # This can be removed post 24.11; it was only ever in unstable
    (lib.mkRenamedOptionModule
      [ "hardware" "amdgpu" "initrd" "enable" ]
      [ "hardware" "amdgpu" "kernelModule" "inInitrd" ]
    )
  ];

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

    boot.initrd.kernelModules = lib.optionals cfg.kernelModule.inInitrd [ "amdgpu" ];

    boot.extraModulePackages = lib.mkIf (cfg.kernelModule.patches != [ ]) [
      (pkgs.callPackage ./amdgpu-kernel-module.nix {
        inherit (config.boot.kernelPackages) kernel;
        inherit (cfg.kernelModule) patches;
      })
    ];

    hardware.graphics = lib.mkIf cfg.opencl.enable {
      enable = lib.mkDefault true;
      extraPackages = [
        pkgs.rocmPackages.clr
        pkgs.rocmPackages.clr.icd
      ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      johnrtitor
      atemu
    ];
  };
}
