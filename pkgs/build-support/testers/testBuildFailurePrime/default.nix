{
  lib,
  stdenvNoCC,
  testers,
}:
# See https://nixos.org/manual/nixpkgs/unstable/#tester-testBuildFailurePrime
# or doc/build-helpers/testers.chapter.md
lib.makeOverridable (
  {
    drv,
    name ? "testBuildFailure-${drv.name}",
    expectedBuilderExitCode ? 1,
    expectedBuilderLogEntries ? [ ],
    script ? "",
  }:
  stdenvNoCC.mkDerivation (finalAttrs: {
    __structuredAttrs = true;
    strictDeps = true;

    inherit name;

    nativeBuildInputs = [ finalAttrs.failed ];

    failed = testers.testBuildFailure drv;

    inherit expectedBuilderExitCode expectedBuilderLogEntries;

    inherit script;

    buildCommandPath = ./build-command.sh;

    meta = {
      description = "Wrapper around testers.testBuildFailure to simplify common use cases";
      maintainers = [ lib.maintainers.connorbaker ];
    };
  })
)
