# `dhallPackageToNix` is a utility function to take a Nixpkgs Dhall package
# (created with a function like `dhallPackages.buildDhallDirectoryPackage`)
# and read it in as a Nix expression.
#
# This function is similar to `dhallToNix`, but takes a Nixpkgs Dhall package
# as input instead of raw Dhall code.
#
# Note that this uses "import from derivation" (IFD), meaning that Nix will
# perform a build during the evaluation phase if you use this
# `dhallPackageToNix` utility.  It is not possible to use `dhallPackageToNix`
# in Nixpkgs, since the Nixpkgs Hydra doesn't allow IFD.

{ stdenv, dhall-nix }:

dhallPackage:
let
  drv = stdenv.mkDerivation {
    name = "dhall-compiled-package.nix";

    buildCommand = ''
      # Dhall requires that the cache is writable, even if it is never written to.
      # We copy the cache from the input package to the current directory and
      # set the cache as writable.
      cp -r "${dhallPackage}/.cache" ./
      export XDG_CACHE_HOME=$PWD/.cache
      chmod -R +w ./.cache

      dhall-to-nix <<< "${dhallPackage}/binary.dhall" > $out
    '';

    nativeBuildInputs = [ dhall-nix ];
  };

in
import drv
