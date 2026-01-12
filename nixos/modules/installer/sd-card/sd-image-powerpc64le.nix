# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-powerpc64le.nix -A config.system.build.sdImage
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
    ./sd-image.nix
  ];

  boot.loader = {
    # powerpc64le-linux typically uses petitboot
    grub.enable = false;
    generic-extlinux-compatible = {
      # petitboot is not does not support all of the extlinux extensions to
      # syslinux, but its parser is very forgiving; it essentially ignores
      # whatever it doesn't understand.  See below for a filename adjustment.
      enable = true;
    };
  };

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelParams = [ "console=hvc0" ];

  sdImage = {
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
        -c ${config.system.build.toplevel} \
        -d ./files/boot
    ''
    # https://github.com/open-power/petitboot/blob/master/discover/syslinux-parser.c
    # petitboot will look in these paths (plus all-caps versions of them):
    #  /boot/syslinux/syslinux.cfg
    #  /syslinux/syslinux.cfg
    #  /syslinux.cfg
    + ''
      mv ./files/boot/extlinux ./files/boot/syslinux
      mv ./files/boot/syslinux/extlinux.conf ./files/boot/syslinux/syslinux.cfg
    ''
    # petitboot does not support relative paths for LINUX or INITRD; it prepends
    # a `/` when parsing these fields
    + ''
      sed -i 's_^\(\W\W*\(INITRD\|initrd\|LINUX\|linux\)\W\)\.\./_\1/boot/_' ./files/boot/syslinux/syslinux.cfg
    '';
  };
}
