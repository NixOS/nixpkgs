{ lib, pythonPackages, fetchPypi, mopidy, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Moped";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FUYRdAN9h6+T3VmiNtQnXFq/cc6gZw//8kp9A5moouQ=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ mopidy ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/martijnboland/moped";
    description = "Web client for Mopidy";
    license = licenses.mit;
    maintainers = [];
    hydraPlatforms = [];
  };
}
