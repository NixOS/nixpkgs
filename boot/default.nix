{ stdenv, bash, bashStatic, coreutils, findutilsWrapper, utillinux, utillinuxStatic, sysvinit, e2fsprogs
, nettools, nix, subversion, gcc, wget, which, vim, less, screen, openssh
, binutils, strace, shadowutils, iputils, gnumake, curl, gnused, gnugrep
, gnutar, gzip, mingettyWrapper, grubWrapper, parted, module_init_tools
, udev, dhcpWrapper, man, nano}:

derivation {
  name = "boot";
  system = stdenv.system;
  builder = ./builder.sh;
  boot = ./boot.sh;
  halt = ./halt.sh;
  login = ./login.sh;
  env = ./env.sh;
  inherit stdenv bash bashStatic coreutils findutilsWrapper utillinux sysvinit
          e2fsprogs nettools nix subversion gcc wget which vim less screen
          openssh binutils strace shadowutils iputils gnumake curl gnused
          gnutar gnugrep gzip mingettyWrapper grubWrapper parted module_init_tools
          udev dhcpWrapper man nano;
}
