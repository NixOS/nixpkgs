/*
  Run all tests with:

      cd nixpkgs
      nix-build -A tests.trivial-builders

  or run a specific test with:

      cd nixpkgs
      nix-build -A tests.trivial-builders.foo

*/

{ callPackage, lib }:
let
  inherit (lib) recurseIntoAttrs;
in
recurseIntoAttrs {
  concat = callPackage ./concat-test.nix {};
  linkFarm = callPackage ./link-farm.nix {};
  overriding = callPackage ../test-overriding.nix {};
  references = callPackage ./references.nix {};
  writeCBin = callPackage ./writeCBin.nix {};
  writeScriptBin = callPackage ./writeScriptBin.nix {};
  writeShellScript = callPackage ./write-shell-script.nix {};
  writeShellScriptBin = callPackage ./writeShellScriptBin.nix {};
  writeStringReferencesToFile = callPackage ./writeStringReferencesToFile.nix {};
  writeTextFile = callPackage ./write-text-file.nix {};
}
