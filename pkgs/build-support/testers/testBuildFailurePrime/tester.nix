# NOTE: Must be `import`-ed rather than `callPackage`-d to preserve the `override` attribute.
{
  lib,
  stdenvNoCC,
  testers,
}:
let
  inherit (lib) maintainers;
  inherit (lib.customisation) makeOverridable;
  inherit (testers) testBuildFailure;

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-testBuildFailurePrime
  # or doc/build-helpers/testers.chapter.md
  testBuildFailure' =
    {
      drv,
      name ? "testBuildFailure-${drv.name}",
      expectedBuilderExitCode ? 1,
      expectedBuilderLogEntries ? [ ],
      script ? "",
    }:
    let
      failed = testBuildFailure drv;
    in
    stdenvNoCC.mkDerivation {
      __structuredAttrs = true;
      strictDeps = true;

      inherit name;

      nativeBuildInputs = [ failed ];

      inherit failed;

      inherit expectedBuilderExitCode expectedBuilderLogEntries;

      inherit script;

      buildCommandPath = ./build-command.sh;

      meta = {
        description = "A wrapper around testers.testBuildFailure to simplify common use cases";
        maintainers = [ maintainers.connorbaker ];
      };
    };
in
makeOverridable testBuildFailure'
