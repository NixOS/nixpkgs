# This module defines a small NixOS configuration.  It does not contain any
# graphical stuff but contains many tools useful for the rescue.

{config, pkgs, ...}:

{
  require = [ ./minimal.nix ];

  # Useful for rescue..
  environment.systemPackages = with pkgs; [
    utillinuxCurses ddrescue 
    pciutils sdparm hdparm hddtemp usbutils
    btrfsProgs xfsprogs jfsutils jfsrec
    iproute 
    fuse ntfs3g smbfsFuse sshfsFuse
    manpages irssi elinks mcabber mutt openssh lftp 
    openssl ncat socat
    gnupg1 gnupg
    patch which diffutils gcc binutils bc file
    screen
    bvi joe nvi 
    subversion16 monotone git darcs mercurial bazaar cvs
    unrar unzip zip lzma cabextract cpio 
    lsof
  ];

  boot.kernelPackages = pkgs.linuxPackages_2_6_32;

  boot.initrd.kernelModules = [
    "evdev" "i8042" "pcips2" "serio" "sd_mod" "libata" "unix" "usbhid"
    "uhci_hcd" "atkbd" "xtkbd" "fbdev" "iso9660" "udf" "loop"
  ];

  boot.kernelModules = [
    "fbcon"
    "radeonfb"
    "intelfb"
    "sisfb"
    "nvidiafb"
    "cirrusfb"
  ];

  boot.kernelParams = [
    "selinux=0"
    "acpi=on"
    "apm=off"
    "console=tty1"
    "splash=verbose"
  ];

  services.ttyBackgrounds.enable = false;
}
