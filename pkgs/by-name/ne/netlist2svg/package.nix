{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommandLocal,
  netlist2svg,
  yosys,
}:

buildNpmPackage rec {
  pname = "netlist2svg";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "ajsb85";
    repo = "netlist2svg";
    tag = "v${version}";
    hash = "sha256-/BH4XRDHf2k12LNBZci1yLDJ3ZFukIRZvLT1CrhLUc0=";
  };

  npmDepsHash = "sha256-dmK6SeiG+QgpA8IVZ6xiRoIRF1Zair3XeBOQCvjhwAE=";

  __structuredAttrs = true;

  dontNpmBuild = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    node --trace-warnings test/test-all.js

    runHook postCheck
  '';

  # An integration test: Synthesize a circuit from hdl and generate a diagram
  passthru.tests.netlist2svg-yosys-integration-test =
    runCommandLocal "netlist2svg-yosys-integration-test"
      {
        nativeBuildInputs = [
          netlist2svg
          yosys
        ];
      }
      ''
        yosys -p "prep -top helloworld -flatten; aigmap; write_json circuit.json" ${./test.v}
        netlist2svg circuit.json -o circuit.svg
        test -s circuit.svg
        touch $out
      '';

  meta = {
    description = "Draw SVG digital circuits schematics from yosys JSON netlists";
    homepage = "https://github.com/ajsb85/netlist2svg";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
