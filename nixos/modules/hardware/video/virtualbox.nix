{ lib, config, ... }:
let
  inherit (config.boot) kernelPackages;
  inherit (config.services.xserver) videoDrivers;
in
{
  config = lib.mkIf (lib.elem "virtualbox" videoDrivers) {
    assertions = [
      {
        assertion = lib.versionOlder kernelPackages.kernel.version "7.0";
        message = ''
          The `virtualbox` video driver provided by VirtualBox Guest Additions has been deprecated upstream for Linux kernel 7.0+.
        '';
      }
    ];

    boot.extraModulePackages = [
      kernelPackages.virtualboxGuestAdditions
    ];
  };
}
