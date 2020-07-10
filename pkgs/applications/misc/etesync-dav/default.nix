{ lib, python3Packages, radicale2 }:

python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.17.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0lyjv8rknwbx5b5nvq5bgw26lhkymib4cvmv3s3469mrnn2c0ksp";
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
