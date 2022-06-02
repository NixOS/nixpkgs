{ lib
, stdenv
, python3
, radicale3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      flask_wtf = super.flask_wtf.overridePythonAttrs (old: rec {
        version = "0.15.1";
        src = old.src.override {
          inherit version;
          sha256 = "ff177185f891302dc253437fe63081e7a46a4e99aca61dfe086fb23e54fff2dc";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.32.1";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "a4e2ee83932755d29ac39c1e74005ec289880fd2d4d2164f09fe2464a294d720";
  };

  propagatedBuildInputs = with python.pkgs; [
    etebase
    etesync
    flask
    flask_wtf
    (python.pkgs.toPythonModule (radicale3.override { python3 = python; }))
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
