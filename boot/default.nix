{ stdenv, kernel, bash, coreutils, findutils, utillinux, sysvinit, e2fsprogs
, nettools, nix, subversion, gcc, wget, which, vim, less, screen, openssh
, binutils, strace, shadowutils, iputils, gnumake, curl, gnused, gnugrep
, gnutar, gzip, mingetty, grubWrapper, parted, modutils}:

derivation {
  name = "boot";
  system = stdenv.system;
  builder = ./builder.sh;
  boot = ./boot.sh;
  halt = ./halt.sh;
  login = ./login.sh;
  env = ./env.sh;
  inherit stdenv kernel bash coreutils findutils utillinux sysvinit
          e2fsprogs nettools nix subversion gcc wget which vim less screen
          openssh binutils strace shadowutils iputils gnumake curl gnused
          gnutar gnugrep gzip mingetty grubWrapper parted modutils;
}
