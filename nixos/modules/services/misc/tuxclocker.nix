{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.programs.tuxclocker;
in
{
  options.programs.tuxclocker = {
    enable = mkEnableOption ''
      TuxClocker, a hardware control and monitoring program
    '';

    enableAMD = mkEnableOption ''
      AMD GPU controls.
      Sets the `amdgpu.ppfeaturemask` kernel parameter to 0xfffd7fff to enable all TuxClocker controls
    '';

    enabledNVIDIADevices = mkOption {
      type = types.listOf types.int;
      default = [ ];
      example = [
        0
        1
      ];
      description = ''
        Enable NVIDIA GPU controls for a device by index.
        Sets the `Coolbits` Xorg option to enable all TuxClocker controls.
      '';
    };

    useUnfree = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to use components requiring unfree dependencies.
        Disabling this allows you to get everything from the binary cache.
      '';
    };
  };

  config =
    let
      package = if cfg.useUnfree then pkgs.tuxclocker else pkgs.tuxclocker-without-unfree;
    in
    mkIf cfg.enable {
      environment.systemPackages = [
        package
      ];

      services.dbus.packages = [
        package
      ];

      # MSR is used for some features
      boot.kernelModules = [ "msr" ];

      # https://download.nvidia.com/XFree86/Linux-x86_64/430.14/README/xconfigoptions.html#Coolbits
      services.xserver.config =
        let
          configSection = (
            i: ''
              Section "Device"
                Driver "nvidia"
                Option "Coolbits" "31"
                Identifier "Device-nvidia[${toString i}]"
              EndSection
            ''
          );
        in
        concatStrings (map configSection cfg.enabledNVIDIADevices);

      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd/include/amd_shared.h#n207
      # Enable everything modifiable in TuxClocker
      boot.kernelParams = mkIf cfg.enableAMD [ "amdgpu.ppfeaturemask=0xfffd7fff" ];
    };
}
