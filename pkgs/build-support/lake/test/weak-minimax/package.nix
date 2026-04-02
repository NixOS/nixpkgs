# Test that buildLakePackage works with nix-only deps (no lake-manifest.json).
# Builds a Lean proof of the weak minimax inequality using mathlib.
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

runCommand "buildLakePackage-weak-minimax" { } ''
  mkdir -p $out

  # Verify library output has compiled oleans.
  test -d "${testPackage}/.lake/build/lib/lean"
  touch $out/success
''
