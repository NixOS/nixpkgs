{
  lib,
  python3Packages,
  fetchPypi,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Bandcamp";
  version = "1.1.5";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wg9zcOKfZQRhpyA1Cu5wvdwKpmrlcr2m9mrqBHgUXAQ=";
  };

  propagatedBuildInputs = with python3Packages; [
    mopidy
    pykka
  ];

  meta = with lib; {
    description = "Mopidy extension for playing music from bandcamp";
    homepage = "https://github.com/impliedchaos/mopidy-bandcamp";
    license = licenses.mit;
    maintainers = with maintainers; [ desttinghim ];
  };
}
