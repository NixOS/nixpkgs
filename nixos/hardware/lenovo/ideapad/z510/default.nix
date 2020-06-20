{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  # https://github.com/NixOS/nixpkgs/issues/18356
  boot.blacklistedKernelModules = [ "nouveau" ];
}
