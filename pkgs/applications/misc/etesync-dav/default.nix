{ lib, python3Packages, radicale2 }:

python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.16.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1r0d52rlhg7dz6hziplzy7ypsfx9lgbs76j3ylinh2csplwkzv69";
  };

  propagatedBuildInputs = with python3Packages; [
    etesync
    flask
    flask_wtf
    radicale2
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
