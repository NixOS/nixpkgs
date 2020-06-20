{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/hdd # TODO: reverse compat
    ../tp-smapi.nix
  ];
}
