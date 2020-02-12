{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/amd
  ];

  # see https://github.com/NixOS/nixpkgs/issues/69289
  boot.kernelPackages = lib.mkIf (lib.versionOlder linux.version "5.2") pkgs.linuxPackages_latest;
}
