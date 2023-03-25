{ lib
, stdenv
, python3
, radicale3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      flask = super.flask.overridePythonAttrs (old: rec {
        version = "2.0.3";
        src = old.src.override {
          inherit version;
          hash = "sha256-4RIMIoyi9VO0cN9KX6knq2YlhGdSYGmYGz6wqRkCaH0=";
        };
      });
      flask-wtf = super.flask-wtf.overridePythonAttrs (old: rec {
        version = "0.15.1";
        src = old.src.override {
          inherit version;
          hash = "sha256-/xdxhfiRMC3CU0N/5jCB56RqTpmsph3+CG+yPlT/8tw=";
        };
        disabledTests = [
          "test_outside_request"
        ];
        disabledTestPaths = [
          "tests/test_form.py"
          "tests/test_html5.py"
        ];
        patches = [ ];
      });
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "2.0.3";
        src = old.src.override {
          inherit version;
          hash = "sha256-uGP4/wV8UiFktgZ8niiwQRYbS+W6TQ2s7qpQoWOCLTw=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.32.1";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-pOLug5MnVdKaw5wedABewomID9LU0hZPCf4kZKKU1yA=";
  };

  propagatedBuildInputs = with python.pkgs; [
    appdirs
    etebase
    etesync
    flask
    flask-wtf
    msgpack
    setuptools
    (python.pkgs.toPythonModule (radicale3.override { python3 = python; }))
    requests
  ] ++ requests.optional-dependencies.socks;

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "Secure, end-to-end encrypted, and privacy respecting sync for contacts, calendars and tasks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ thyol valodim ];
    broken = stdenv.isDarwin; # pyobjc-framework-Cocoa is missing
  };
}
