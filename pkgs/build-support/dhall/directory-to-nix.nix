{ dhallPackages, dhallPackageToNix }:

# `dhallDirectoryToNix is a utility function to take a directory of Dhall files
# and read them in as a Nix expression.
#
# This function is similar to `dhallToNix`, but takes a Nixpkgs Dhall package
# as input instead of raw Dhall code.
#
# Note that this uses "import from derivation" (IFD), meaning that Nix will
# perform a build during the evaluation phase if you use this
# `dhallDirectoryToNix` utility.  It is not possible to use
# `dhallDirectoryToNix` in Nixpkgs, since the Nixpkgs Hydra doesn't allow IFD.

{
  src,
  # The file to import, relative to the src root directory
  file ? "package.dhall",
}@args:

let
  generatedPkg = dhallPackages.generateDhallDirectoryPackage args;

  builtPkg = dhallPackages.callPackage generatedPkg { };

in
dhallPackageToNix builtPkg
