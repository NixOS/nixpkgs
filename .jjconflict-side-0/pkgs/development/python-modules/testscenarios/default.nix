{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pbr,
  setuptools,

  # dependencies
  testtools,

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "testscenarios";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c257cb6b90ea7e6f8fef3158121d430543412c9a87df30b5dde6ec8b9b57a2b6";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "buffer = 1" "" \
      --replace "catch = 1" ""
  '';

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    pbr
    testtools
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m testtools.run testscenarios.tests.test_suite

    runHook postCheck
  '';

  meta = with lib; {
    description = "Pyunit extension for dependency injection";
    homepage = "https://github.com/testing-cabal/testscenarios";
    license = licenses.asl20;
  };
}
