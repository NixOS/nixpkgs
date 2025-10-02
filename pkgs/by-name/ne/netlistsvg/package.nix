{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommandLocal,
  netlistsvg,
  yosys,
}:

buildNpmPackage rec {
  pname = "netlistsvg";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "nturley";
    repo = "netlistsvg";
    tag = "v${version}";
    hash = "sha256-H37zhjfv7c/TV+pAk70eDiE6ZQ9JjZq1TFvac6OOKBk=";
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-Vs0RLj6ySkM5oQsBGv4MmgiIBMhiDhINpwuCBJH9L8s=";

  dontNpmBuild = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    node --trace-warnings test/test-all.js

    runHook postCheck
  '';

  # An integration test: Synthesize a circuit from hdl and generate a diagram
  passthru.tests.netlistsvg-yosys-integration-test =
    runCommandLocal "netlistsvg-yosys-integration-test"
      {
        nativeBuildInputs = [
          netlistsvg
          yosys
        ];
      }
      ''
        yosys -p "prep -top helloworld -flatten; aigmap; write_json circuit.json" ${./test.v}
        netlistsvg circuit.json -o circuit.svg
        test -s circuit.svg
        touch $out
      '';

  meta = {
    description = "Draw SVG digital circuits schematics from yosys JSON netlists";
    homepage = "https://github.com/nturley/netlistsvg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
