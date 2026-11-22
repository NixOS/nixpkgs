{
  runCommand,
  lean4,
  leanPackages,
}:

let
  thisLeanPackages = leanPackages.overrideScope (
    _: _: {
      inherit lean4;
    }
  );
in

{
  smoke = runCommand "lean4-smoke-test" { nativeBuildInputs = [ lean4 ]; } ''
    lean --stdin <<EOF
    import Std
    example : 1 + 1 = 2 := by decide
    example : ∀ (x y : BitVec 8), x &&& y = y &&& x := by bv_decide
    EOF

    lake new hello
    lake -d hello --no-ansi exe hello

    touch $out
  '';

  checktest = thisLeanPackages.buildLakePackage {
    pname = "lean4-check-test";
    version = "0.1.0";
    src = "${lean4.unwrapped.src}/tests/lake/tests/check-paranoid";
    checkPhase = ''
      lake check --paranoid --inadvisably-no-sandbox
      lake comparator --config config.json --paranoid --inadvisably-no-sandbox
    '';
    doCheck = true;
  };
}
