{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-iris";
  version = "3.70.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mopidy_iris";
    inherit version;
    hash = "sha256-md/1blTTtjiAAb/jiLE2EfiSlIUwEga8U7OiuKa466k=";
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

  meta = with lib; {
    homepage = "https://github.com/jaedb/Iris";
    description = "Fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
