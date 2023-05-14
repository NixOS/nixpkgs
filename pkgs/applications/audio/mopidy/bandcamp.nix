{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Bandcamp";
  version = "1.1.5";
  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-wg9zcOKfZQRhpyA1Cu5wvdwKpmrlcr2m9mrqBHgUXAQ=";
  };

  propagatedBuildInputs = with python3Packages; [ mopidy pykka ];

  meta = with lib; {
    description = "Mopidy extension for playing music from bandcamp";
    homepage = "https://github.com/impliedchaos/mopidy-bandcamp";
    license = licenses.mit;
    maintainers = with maintainers; [ desttinghim ];
  };
}
