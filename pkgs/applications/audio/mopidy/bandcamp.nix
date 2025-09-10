{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-bandcamp";
  version = "1.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Bandcamp";
    hash = "sha256-wg9zcOKfZQRhpyA1Cu5wvdwKpmrlcr2m9mrqBHgUXAQ=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.pykka
  ];

  pythonImportsCheck = [ "mopidy_bandcamp" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from bandcamp";
    homepage = "https://github.com/impliedchaos/mopidy-bandcamp";
    license = licenses.mit;
    maintainers = with maintainers; [ desttinghim ];
  };
}
