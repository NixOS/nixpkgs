{ lib
, stdenv
, fetchpatch
, nixosTests
, python3
, fetchPypi
, radicale3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.32.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pOLug5MnVdKaw5wedABewomID9LU0hZPCf4kZKKU1yA=";
  };

  patches = [
    (fetchpatch {
      name = "add-missing-comma-in-setup.py.patch";
      url = "https://github.com/etesync/etesync-dav/commit/040cb7b57205e70515019fb356e508a6414da11e.patch";
      hash = "sha256-87IpIQ87rgpinvbRwUlWd0xeegn0zfVSiDFYNUqPerg=";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    etebase
    etesync
    flask
    flask-wtf
    msgpack
    setuptools
    (python.pkgs.toPythonModule (radicale3.override { python3 = python; }))
    requests
    types-setuptools
  ] ++ requests.optional-dependencies.socks;

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) etesync-dav;
  };

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "Secure, end-to-end encrypted, and privacy respecting sync for contacts, calendars and tasks";
    mainProgram = "etesync-dav";
    license = licenses.gpl3;
    maintainers = with maintainers; [ thyol valodim ];
    broken = stdenv.isDarwin; # pyobjc-framework-Cocoa is missing
  };
}
