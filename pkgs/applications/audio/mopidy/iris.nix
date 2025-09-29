{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-iris";
  version = "3.69.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Iris";
    hash = "sha256-PEAXnapiyxozijR053I7zQYRYLeDOV719L0QbO2r4r4=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.configobj
    pythonPackages.requests
    pythonPackages.tornado
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "mopidy_iris" ];

  meta = {
    homepage = "https://github.com/jaedb/Iris";
    description = "Fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rvolosatovs ];
  };
}
