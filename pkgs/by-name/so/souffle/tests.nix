{ stdenv, lib, souffle, runCommand }:
let
  simpleTest = { name, commands }:
    stdenv.mkDerivation {
      inherit name;
      meta.timeout = 60;
      buildCommand = ''
        echo -e '.decl A(X: number)\n.output A\nA(1).' > A.dl
        ${commands}
        [ "$(cat A.csv)" = "1" ]
        touch $out
      '';
    };
in {
  interpret = simpleTest {
    name = "souffle-test-interpret";
    commands = "${souffle}/bin/souffle A.dl";
  };

  compile-in-one-step = simpleTest {
    name = "souffle-test-compile-in-one-step";
    commands = ''
      ${souffle}/bin/souffle -o A A.dl
      ./A
    '';
  };

  compile-in-two-steps = simpleTest {
    name = "souffle-test-compile-in-two-steps";
    commands = ''
      ${souffle}/bin/souffle -g A.cpp A.dl
      ${souffle}/bin/souffle-compile.py A.cpp -o A
      ./A
    '';
  };
}
