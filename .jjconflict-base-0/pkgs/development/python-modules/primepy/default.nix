{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "primepy";
  version = "1.3";
  pyproject = true;

  src = fetchPypi {
    pname = "primePy";
    inherit version;
    hash = "sha256-Jf1+JTRLB4mlmEx12J8FT88fGAvvIMmY5L77rJLeRmk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "primePy" ];

  meta = with lib; {
    description = "This module contains several useful functions to work with prime numbers. from primePy import primes";
    homepage = "https://pypi.org/project/primePy/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
