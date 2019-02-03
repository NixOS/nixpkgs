# This module defines a small netboot environment.

{ config, ... }:

{
  imports = [
    ../cd-dvd/installation-cd-base.nix
  ];
  boot.initrd.network.enable = true;
  boot.devSize = "600m";

  # TODO add all network modules
  boot.initrd.kernelModules = [ "e1000" ];

  # needed for dns in initrd
  boot.initrd.extraUtilsCommands =''
    cp ${pkgs.stdenv.cc.libc}/lib/libnss_dns.so.* $out/lib/
  '';

  boot.initrd.network.postCommands = ''
    iso_link=https://releases.nixos.org$(wget -O- 'https://nixos.org/channels/nixos-${config.system.nixos.release}' | grep -o "/nixos/[^']*minimal[^']*x86_64-linux.iso")
    wget "$iso_link" -O /dev/root
  '';
  boot.initrd.postMountCommands = ''
    export stage2Init=$(find /mnt-root/nix/store -type f -name init | grep 'nixos-system' | sed 's@^/mnt-root@@')
  '';

  system.build.netbootIpxeScript = pkgs.writeTextDir "netboot.ipxe" ''
    #!ipxe
    kernel ${pkgs.stdenv.hostPlatform.platform.kernelTarget} init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
    initrd initrd
    boot
  '';
}
