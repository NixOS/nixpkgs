/*
  Run all tests with:

      cd nixpkgs
      nix-build -A tests.trivial-builders

  or run a specific test with:

      cd nixpkgs
      nix-build -A tests.trivial-builders.foo

*/

{ callPackage, lib, stdenv, tests }:
let
  inherit (lib) recurseIntoAttrs;
  references = callPackage ./references {};
  # To override the `samples` for all other test cases, pass the new
  # `samples` to `references.override` in Nixpkgs overlays.
  final-references = tests.trivial-builders.references;
in
recurseIntoAttrs {
  concat = callPackage ./concat-test.nix {};
  linkFarm = callPackage ./link-farm.nix {};
  overriding = callPackage ../test-overriding.nix {};
  # VM test not supported beyond linux yet, while non-Linux users can
  # still run the test by executing `references.testScriptBin`, and
  # access passthru attributes like `samples`, the way Linux users do.
  # Use `references.override` to override these attributes.
  references =
    if stdenv.hostPlatform.isLinux then
      references
    else
      lib.makeOverridable (lib.mirrorFunctionArgs references.override (referenceArgs:
      let
        references-overridden = references.override referenceArgs;
      in
      {
        inherit (references-overridden)
          samples
          references
          directReferences
          testScriptBin
        ;
        meta = { inherit (references-overridden.meta) maintainers; };
      }
      )) { };
  writeCBin = callPackage ./writeCBin.nix {};
  writeShellApplication = callPackage ./writeShellApplication.nix {};
  writeScriptBin = callPackage ./writeScriptBin.nix {};
  writeShellScript = callPackage ./write-shell-script.nix {};
  writeShellScriptBin = callPackage ./writeShellScriptBin.nix {};
  writeStringReferencesToFile = callPackage ./writeStringReferencesToFile.nix {
    inherit (final-references) samples;
  };
  writeTextFile = callPackage ./write-text-file.nix {};
}
