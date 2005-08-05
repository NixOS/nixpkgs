{ stdenv, bash, coreutils, utillinux, e2fsprogs, nix, shadowutils, mingetty, grub, parted}:

derivation {
  name = "init";
  system = stdenv.system;
  builder = ./builder.sh;
  stage1 = ./prepare-disk.sh;
  stage2 = ./fill-disk.sh;
  inherit stdenv bash coreutils utillinux e2fsprogs nix shadowutils
          mingetty grub parted;
}
