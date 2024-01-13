/*
  Run all tests with:

      cd nixpkgs
      nix-build -A tests.trivial-builders

  or run a specific test with:

      cd nixpkgs
      nix-build -A tests.trivial-builders.foo

*/

{ callPackage, lib, stdenv }:
let
  inherit (lib) recurseIntoAttrs;
  references = callPackage ./references {};
in
recurseIntoAttrs {
  concat = callPackage ./concat-test.nix {};
  linkFarm = callPackage ./link-farm.nix {};
  overriding = callPackage ../test-overriding.nix {};
  # VM test not supported beyond linux yet
  references =
    if stdenv.hostPlatform.isLinux
    then references
    else {};
  writeCBin = callPackage ./writeCBin.nix {};
  writeShellApplication = callPackage ./writeShellApplication.nix {};
  writeScriptBin = callPackage ./writeScriptBin.nix {};
  writeShellScript = callPackage ./write-shell-script.nix {};
  writeShellScriptBin = callPackage ./writeShellScriptBin.nix {};
  writeStringReferencesToFile = callPackage ./writeStringReferencesToFile.nix {
    inherit (references) samples;
  };
  writeTextFile = callPackage ./write-text-file.nix {};
}
