{stdenv, bash, coreutils, findutils, utillinux, sysvinit, e2fsprogs, nix}:

derivation {
  name = "boot";
  system = stdenv.system;
  builder = ./builder.sh;
  boot = ./boot.sh;
  halt = ./halt.sh;
  login = ./login.sh;
  inherit stdenv bash coreutils findutils utillinux sysvinit e2fsprogs nix;
}
