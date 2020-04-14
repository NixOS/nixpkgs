{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../.
  ];
}
