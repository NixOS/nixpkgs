rec {
  inherit (import /nixpkgs/trunk/pkgs/system/i686-linux.nix)
    stdenv kernel bash bashStatic coreutils coreutilsDiet findutilsWrapper utillinux utillinuxStatic sysvinit
   e2fsprogsDiet e2fsprogs
    nettools nix subversion gcc wget which vim less screen openssh binutils
    strace shadowutils iputils gnumake curl gnused gnutar gnugrep gzip
    mingettyWrapper grubWrapper syslinux parted module_init_tools module_init_toolsStatic hotplug udev
    dhcpWrapper man nano eject sysklogd kudzu;

  boot = (import ./boot) {inherit stdenv kernel bash bashStatic coreutils findutilsWrapper
    utillinux utillinuxStatic sysvinit e2fsprogs nettools nix subversion gcc wget which vim
    less screen openssh binutils strace shadowutils iputils gnumake curl
    gnused gnutar gnugrep gzip mingettyWrapper grubWrapper parted module_init_tools
    hotplug udev dhcpWrapper man nano;};

  init = (import ./init) {inherit stdenv bash bashStatic coreutilsDiet utillinux e2fsprogsDiet
    nix shadowutils mingettyWrapper grubWrapper parted module_init_tools hotplug
    dhcpWrapper man nano eject;};

  everything = [boot sysvinit kernel sysklogd kudzu];
}
