{ lib, python3Packages, radicale3 }:

python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.30.6";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0cjz4p3a750fwvrxbzwda0sidw7nscahvppdshbsx49i6qrczpbg";
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
  };
}
