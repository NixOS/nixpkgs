rec {
  inherit (import /nixpkgs/trunk/pkgs/system/i686-linux.nix)
    stdenv kernel bash coreutils findutilsWrapper utillinux sysvinit e2fsprogs
    nettools nix subversion gcc wget which vim less screen openssh binutils
    strace shadowutils iputils gnumake curl gnused gnutar gnugrep gzip
    mingetty grubWrapper syslinux parted module_init_tools hotplug udev
    dhcpWrapper man nano;

  boot = (import ./boot) {inherit stdenv kernel bash coreutils findutilsWrapper
    utillinux sysvinit e2fsprogs nettools nix subversion gcc wget which vim
    less screen openssh binutils strace shadowutils iputils gnumake curl
    gnused gnutar gnugrep gzip mingetty grubWrapper parted module_init_tools
    hotplug udev dhcpWrapper man nano;};

  init = (import ./init) {inherit stdenv bash coreutils utillinux e2fsprogs
    nix shadowutils mingetty grubWrapper parted module_init_tools hotplug
    dhcpWrapper man nano;};

  everything = [boot sysvinit kernel];
}
