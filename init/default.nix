{stdenv, bash, coreutils, findutils, utillinux, sysvinit, e2fsprogs, nix}:

derivation {
  name = "init";
  system = stdenv.system;
  builder = ./builder.sh;
  src = ./init.sh;
  inherit stdenv bash coreutils findutils utillinux sysvinit e2fsprogs nix;
}
