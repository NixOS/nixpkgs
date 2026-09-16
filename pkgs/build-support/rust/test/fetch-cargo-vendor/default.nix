{ callPackage }:

# Build like this from nixpkgs root:
# $ nix-build -A tests.fetchCargoVendor
{
  basicSparse = callPackage ./basic-sparse { };
  customSparse = callPackage ./custom-sparse { };
}
