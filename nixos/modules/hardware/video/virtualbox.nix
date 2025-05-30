{ lib, config, ... }:
let
  inherit (config.boot) kernelPackages;
  inherit (config.services.xserver) videoDrivers;
in
{
  boot.extraModulePackages = lib.mkIf (lib.elem "virtualbox" videoDrivers) [
    kernelPackages.virtualboxGuestAdditions
  ];
}
