{ lib, stdenv, python3Packages, radicale3 }:

python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.30.7";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "16b3105834dd6d9e374e976cad0978e1acfed0f0328c5054bc214550aea3e2c5";
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
