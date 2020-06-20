This config is for [Librem 13v3](https://puri.sm/products/librem-13/) and [15v3](https://puri.sm/products/librem-15/) Laptops from Purism.


Librem comes with Coreboot + SeaBIOS payload. That means EFI boot is not
possible. Use `fdisk` to partition hard drive, and GRUB as a bootloader:

```nix
{
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    version = 2;
  };
}
```

## Adding a PureOS partition to the GRUB menu

I first assume that `boot.loader.grub.useOSProber = true;` should be sufficient.
However GRUB was not able to identify the disks correctly and it took me several
reinstallation till setting `boot.loader.grub.fsIdentifier= "provided";` and using
boot.loader.grub.extraEntries allowed me to dual boot NixOS and PureOS.

Be aware that each time the PureOS updates the /boot/grub/grub.cfg you will be unable
to boot into NixOS unless you patch grub.cfg manually again.

Therefore: If you want to be able to boot into your old PureOS distribution
add the following lines, assuming that you have a separate boot partition
Adapt linux version and the UUID to your disk!!


```nix
{
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.fsIdentifier= "provided";
  boot.loader.grub.extraEntries = ''
  menuentry "PureOS with linux 4.19.0-5-amd64 on /dev/sdb2 " {
      insmod gzio
      if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
      insmod part_msdos
      insmod ext2
      set root='hd0,msdos1'
      if [ x$feature_platform_search_hint = xy ]; then
        search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1  ef7a4dcf-8cc4-4870-b860-3ed64906f9b9
      else
        search --no-floppy --fs-uuid --set=root ef7a4dcf-8cc4-4870-b860-3ed64906f9b9
      fi
      linux   /vmlinuz-4.19.0-5-amd64 root=UUID=43899f26-04f2-4ccb-b52a-c9441f1a1a6d ro  quiet splash resume=UUID=923317f8-d8bb-4e1f-bca3-f36a556de609 # $vt_handoff
      initrd  /initrd.img-4.19.0-5-amd64
  };
}
```

## Automatically lock the desktop when removing the librem key

The [instructions](https://docs.puri.sm/Librem_Key/Getting_Started/User_Manual.html#automatically-lock-the-desktop-when-removing-the-librem-key) to lock the screen after unplugging the [Librem Key](https://puri.sm/products/librem-key/#overview) don't work under NixOS.

This snippet works on my Librem 15v3 laptop running KDE without wayland and is using the xlock from the package xlockmore.

```nix
{ pkgs, services , systemd, ... }:
let
  libremScreenSaver = pkgs.writeScriptBin "libremScreenSaver" ''
  #!${pkgs.bash}/bin/bash
  user=`ps aux | egrep "start_kdeinit|gdm-(wayland|x)-session"| head -n 1 | awk '{print $1}'`
  if [ -n "$user" ]; then
    sudo -u $user DISPLAY=:0 xlock 2>&1 | logger lockScreen for user $user
  else
    logger libremScreenSaver failed to find a user. Not running KDE?
  fi
  '';

in {
  services.udev.path = [ pkgs.procps pkgs.logger pkgs.gawk pkgs.xlockmore ];
  services.udev.extraRules = ''
    ACTION=="remove", ENV{PRODUCT}=="316d/4c4b/101" RUN+="${pkgs.systemd}/bin/systemctl --no-block start lockScreen@%k.service"
  '';
  systemd.services."lockScreen@" = {
    bindsTo = [ "dev-%i.device"] ;
    path = [ pkgs.procps pkgs.logger pkgs.sudo pkgs.xlockmore pkgs.gawk ] ;
    serviceConfig = {
        Type = "oneshot"; # was simple
        ExecStart = "${libremScreenSaver}/bin/libremScreenSaver %I";
    };
  };
}
```
