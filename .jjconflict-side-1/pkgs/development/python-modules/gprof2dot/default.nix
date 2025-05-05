{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  graphviz,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gprof2dot";
  version = "2025.04.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "gprof2dot";
    tag = version;
    hash = "sha256-kX/DCXO/qwm1iF44gG7aBSUpG4Vf2Aer0zwrtq4YNHo=";
  };

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ graphviz ]}" ];

  # Needed so dot is on path of the test script
  nativeCheckInputs = [ graphviz ];

  checkPhase = ''
    runHook preCheck

    # if options not specified, will use unwrapped gprof2dot from original source
    ${python.interpreter} tests/test.py --python bash --gprof2dot $out/bin/gprof2dot

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python script to convert the output from many profilers into a dot graph";
    mainProgram = "gprof2dot";
    homepage = "https://github.com/jrfonseca/gprof2dot";
    changelog = "https://github.com/jrfonseca/gprof2dot/releases/tag/${src.tag}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
  };
}
