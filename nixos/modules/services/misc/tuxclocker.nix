{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.tuxclocker;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "tuxclocker" "enableAMD" ]
      [ "hardware" "amdgpu" "overdrive" "enable" ]
    )
  ];

  options.programs.tuxclocker = {
    enable = lib.mkEnableOption ''
      TuxClocker, a hardware control and monitoring program
    '';

    enabledNVIDIADevices = lib.mkOption {
      type = lib.types.listOf lib.types.int;
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

    useUnfree = lib.mkOption {
      type = lib.types.bool;
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
    lib.mkIf cfg.enable {
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
        lib.concatStrings (map configSection cfg.enabledNVIDIADevices);
    };
}
