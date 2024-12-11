{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.7.6.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cxYcZ0dOqdgdBLza0WbTmc/z8ITV0twh691GwHW7wmU=";
  };

  propagatedBuildInputs = [ six ];

  # darwin seems to hang
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m ppft.tests
    runHook postCheck
  '';

  pythonImportsCheck = [ "ppft" ];

  meta = with lib; {
    description = "Distributed and parallel Python";
    mainProgram = "ppserver";
    homepage = "https://ppft.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/ppft/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
