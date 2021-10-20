{ lib, stdenv, python3Packages, radicale3 }:

python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.30.8";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-HBLQsq3B6TMdcnUt8ukbk3+S0Ed44+gePkpuGZ2AyC4=";
  };

  propagatedBuildInputs = with python3Packages; [
    etebase
    etesync
    flask
    flask_wtf
    radicale3
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "Secure, end-to-end encrypted, and privacy respecting sync for contacts, calendars and tasks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ valodim ];
    broken = stdenv.isDarwin; # pyobjc-framework-Cocoa is missing
  };
}
