{ python3Packages, qemu }:

python3Packages.callPackage ./package.nix {
  inherit qemu;
}
