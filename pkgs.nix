let 

  pkgs = import ./pkgs/top-level/all-packages.nix {};

  # !!! copied from stdenv/linux/make-bootstrap-tools.nix.
  pkgsToRemove = 
    [ "binutils" "gcc" "coreutils" "findutils" "diffutils" "gnused" "gnugrep"
      "gawk" "gnutar" "gzip" "bzip2" "gnumake" "bash" "patch" "patchelf"
    ];
    
  pkgsDiet = import ./pkgs/top-level/all-packages.nix {
    bootStdenv = removeAttrs (pkgs.useDietLibC pkgs.stdenv) pkgsToRemove;
  };

in rec {

  inherit (pkgs)
    stdenv kernelscripts kernel bash coreutils coreutilsDiet
    findutilsWrapper utillinux utillinuxStatic sysvinit e2fsprogsDiet
    e2fsprogs nettools nix subversion gcc wget which vim less screen
    openssh binutils nixStatic strace shadowutils iputils gnumake curl gnused
    gnutar gnutar151 gnugrep gzip mingettyWrapper grubWrapper syslinux parted
    module_init_tools module_init_toolsStatic dhcpWrapper man nano nanoDiet
    eject sysklogd mktemp cdrtools cpio busybox mkinitrd ncursesDiet;

  diet = pkgsDiet;
    
  boot = (import ./boot) {
    inherit stdenv bash coreutils findutilsWrapper utillinux sysvinit
    e2fsprogs nettools subversion gcc wget which vim less screen openssh
    strace shadowutils iputils gnumake curl gnused gnutar gnugrep gzip
    mingettyWrapper grubWrapper parted module_init_tools dhcpWrapper man
    nano nix;
  };

  #init = (import ./init) {inherit stdenv bash bashStatic coreutilsDiet
  #  utillinux shadowutils mingettyWrapper grubWrapper parted module_init_tools
  #  dhcpWrapper man nano eject e2fsprogsDiet;
  #  nix = nixUnstable;
  #};

  everything = [boot sysvinit sysklogd kernelscripts kernel mkinitrd];
  
}
