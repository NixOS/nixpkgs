{ lib
, stdenv
, python3
, radicale3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      flask-wtf = super.flask-wtf.overridePythonAttrs (old: rec {
        version = "0.15.1";
        src = old.src.override {
          inherit version;
          sha256 = "ff177185f891302dc253437fe63081e7a46a4e99aca61dfe086fb23e54fff2dc";
        };
        disabledTests = [
          "test_outside_request"
        ];
      });
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "2.0.3";
        src = old.src.override {
          inherit version;
          sha256 = "b863f8ff057c522164b6067c9e28b041161b4be5ba4d0daceeaa50a163822d3c";
        };
      });
      wtforms = super.wtforms.overridePythonAttrs (old: rec {
        version = "2.3.3";
        src = old.src.override {
          inherit version;
          sha256 = "81195de0ac94fbc8368abbaf9197b88c4f3ffd6c2719b5bf5fc9da744f3d829c";
        };
        checkPhase = ''
          ${self.python.interpreter} tests/runtests.py
        '';
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
    appdirs
    etebase
    etesync
    flask
    flask-wtf
    msgpack
    (python.pkgs.toPythonModule (radicale3.override { python3 = python; }))
    requests
  ] ++ requests.optional-dependencies.socks;

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "Secure, end-to-end encrypted, and privacy respecting sync for contacts, calendars and tasks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ valodim ];
    broken = stdenv.isDarwin; # pyobjc-framework-Cocoa is missing
  };
}
