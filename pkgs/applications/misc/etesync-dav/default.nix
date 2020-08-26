{ lib, python3Packages, radicale3 }:

python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.20.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1q8h89hqi4kxphn1g5nbcia0haz5k57is9rycwaabm55mj9s9fah";
  };

  propagatedBuildInputs = with python3Packages; [
    etesync
    flask
    flask_wtf
    radicale3
  ];

  checkInputs = with python3Packages; [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "Secure, end-to-end encrypted, and privacy respecting sync for contacts, calendars and tasks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ valodim ];
  };
}
