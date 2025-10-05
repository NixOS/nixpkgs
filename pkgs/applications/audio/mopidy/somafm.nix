{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-somafm";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-SomaFM";
    sha256 = "DC0emxkoWfjGHih2C8nINBFByf521Xf+3Ks4JRxNPLM=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
  ];

  doCheck = false;

  pythonImportsCheck = [ "mopidy_somafm" ];

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for playing music from SomaFM";
    license = licenses.mit;
    maintainers = [ maintainers.nickhu ];
  };
}
