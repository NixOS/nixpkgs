{
  lib,
  stdenv,
  nixosTests,
  python3Packages,
  fetchFromGitHub,
  radicale,
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      peewee = final.peewee_3;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "etesync-dav";
  version = "0.35.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etesync-dav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y4BhU2kSn+RWqc5+pJQFhbwfat9cMWD0ED0EXJp25cY=";
  };

  patches = [
    # https://github.com/etesync/etesync-dav/pull/365
    ./radicale-3-6-compat.patch
  ];

  build-system = with pythonPackages; [ setuptools ];

  pythonRelaxDeps = [ "radicale" ];

  dependencies =
    with pythonPackages;
    [
      appdirs
      etebase
      etesync
      flask
      flask-wtf
      msgpack
      (toPythonModule (radicale.override { python3 = python; }))
      requests
    ]
    ++ requests.optional-dependencies.socks;

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
      valodim
    ];
    broken = stdenv.hostPlatform.isDarwin; # pyobjc-framework-Cocoa is missing
  };
})
