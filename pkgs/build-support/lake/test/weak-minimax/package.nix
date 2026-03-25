# Test that buildLakePackage works with nix-only deps (no lake-manifest.json).
# Builds a Lean proof of the weak minimax inequality using mathlib.
#
# Note: building the executable recompiles .c → .c.o for all transitive
# dependency modules because library packages only ship .olean/.ilean/.c
# artifacts (the default Lake library facet).  Lake's trace system would
# reuse pre-built object files if present, but since Lean 4 is rarely
# used for application code, we defer shipping .o files in library
# packages to keep store footprint minimal.
{
  leanPackages,
  runCommand,
}:

let
  inherit (leanPackages) buildLakePackage mathlib;

  testPackage = buildLakePackage {
    pname = "weak-minimax";
    version = "0";
    src = ./.;

    leanDeps = [ mathlib ];
  };
in

runCommand "buildLakePackage-weak-minimax"
  {
    nativeBuildInputs = [ testPackage ];
  }
  ''
    mkdir -p $out

    # Verify the executable runs (proof was verified at build time).
    weakMinimax-run | tee $out/result
    grep -q "weak_minimax" $out/result

    # Verify library output has compiled oleans.
    test -d "${testPackage}/.lake/build/lib/lean"
  ''
