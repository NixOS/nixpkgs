{ stdenv, bash, coreutils, utillinux, e2fsprogs, nix, shadowutils, mingetty, grub, parted}:

derivation {
  name = "init";
  system = stdenv.system;
  builder = ./builder.sh;
  inherit stdenv bash coreutils utillinux e2fsprogs nix shadowutils
          mingetty grub parted;
}
