{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
  glibcLocales,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-moped";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Moped";
    sha256 = "15461174037d87af93dd59a236d4275c5abf71cea0670ffff24a7d0399a8a2e4";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  build-system = [ pythonPackages.setuptools ];

  dependencies = [ mopidy ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "mopidy_moped" ];

  meta = with lib; {
    homepage = "https://github.com/martijnboland/moped";
    description = "Web client for Mopidy";
    license = licenses.mit;
    maintainers = [ ];
    hydraPlatforms = [ ];
  };
}
