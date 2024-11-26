{ lib
, stdenv
, nixosTests
, python3
, fetchFromGitHub
, radicale3
}:

python3.pkgs.buildPythonApplication {
  pname = "etesync-dav";
  version = "0.32.1-unstable-2024-09-02";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etesync-dav";
    rev = "b9b23bf6fba60d42012008ba06023bccd9109c08";
    hash = "sha256-wWhwnOlwE1rFgROTSj90hlSw4k48fIEdk5CJOXoecuQ=";
  };

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
    broken = stdenv.hostPlatform.isDarwin; # pyobjc-framework-Cocoa is missing
  };
}
