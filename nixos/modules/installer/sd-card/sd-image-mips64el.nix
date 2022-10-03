/*
To build, use:
nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-mips64el.nix -A config.system.build.sdImage

Since mips hardware is found mostly in routers which are optimized
for I/O throughput rather than compilation speed, you probably
want to cross-compile this.  To do so, use:

nix-build nixos \
  -A config.system.build.sdImage \
  --arg configuration '{config,lib,pkgs,...}@args: (import ./nixos/modules/installer/sd-card/sd-image-mips64el.nix args) // { nixpkgs.hostPlatform = lib.systems.examples.octeon; nixpkgs.buildPlatform = builtins.currentSystem; }'
*/
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/base.nix
    ./sd-image.nix
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible = {
      enable = true;
    };
  };

  services.xserver.enable = lib.mkForce false;
  services.xserver.libinput.enable = lib.mkForce false;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelParams = [ "console=ttyS0,115200" ];
  boot.initrd.includeDefaultModules = false;

  sdImage = {
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
