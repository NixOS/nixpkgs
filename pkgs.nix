rec {
  inherit (import /nixpkgs/trunk/pkgs/top-level/all-packages.nix {})
    stdenv kernel bash bashStatic coreutils coreutilsDiet findutilsWrapper
    utillinux utillinuxStatic sysvinit e2fsprogsDiet e2fsprogs nettools
    nixUnstable subversion gcc wget which vim less screen openssh binutils
    nixStatic strace shadowutils iputils gnumake curl gnused gnutar gnugrep
    gzip mingettyWrapper grubWrapper syslinux parted module_init_tools
    module_init_toolsStatic udev dhcpWrapper man nano eject sysklogd mktemp
    cdrtools cpio;

  boot = (import ./boot) {
    inherit stdenv bash bashStatic coreutils findutilsWrapper utillinux
    utillinuxStatic sysvinit e2fsprogs nettools subversion gcc wget which
    vim less screen openssh binutils strace shadowutils iputils gnumake curl
    gnused gnutar gnugrep gzip mingettyWrapper grubWrapper parted
    module_init_tools udev dhcpWrapper man nano;
    nix = nixUnstable;
  };

  init = (import ./init) {inherit stdenv bash bashStatic coreutilsDiet
    utillinux shadowutils mingettyWrapper grubWrapper parted module_init_tools
    dhcpWrapper man nano eject e2fsprogsDiet;
    nix = nixUnstable;
  };

  everything = [boot sysvinit sysklogd kernel ];
}
