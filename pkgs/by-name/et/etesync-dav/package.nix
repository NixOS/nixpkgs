{
  lib,
  stdenv,
  nixosTests,
  python3Packages,
  fetchFromGitHub,
  radicale,
}:
python3Packages.buildPythonApplication rec {
  pname = "etesync-dav";
  version = "0.34.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etesync-dav";
    tag = "v${version}";
    hash = "sha256-+rNqyksOmDUh0OuvgEDWv6tuZQkn1gizz35Ptr6izos=";
  };

  dependencies = with python3Packages; [
    appdirs
    etebase
    etesync
    flask
    flask-wtf
    msgpack
    setuptools
    (python3Packages.toPythonModule (radicale.override { python3 = python; }))
    requests
    types-setuptools
    requests.optional-dependencies.socks
  ];

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) etesync-dav;
  };

  meta = {
    homepage = "https://www.etesync.com";
    description = "Secure, end-to-end encrypted, and privacy respecting sync for contacts, calendars and tasks";
    mainProgram = "etesync-dav";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thyol
      valodim
    ];
    broken = stdenv.hostPlatform.isDarwin; # pyobjc-framework-Cocoa is missing
  };
}
