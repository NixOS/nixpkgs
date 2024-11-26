{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.8.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KqgJiIgm9q9bJsd/x/YT8rvq2g2MwJ5aWOD1loS7aRE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    mainProgram = "xlsx2csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
