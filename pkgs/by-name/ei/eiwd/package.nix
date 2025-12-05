{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3Packages, # for tests
  openssl, # for tests
  enableManpages ? true,
  docutils, # for manpages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eiwd";
  version = "2.22-1";

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "eiwd";
    tag = finalAttrs.version;
    hash = "sha256-rmkXR4RZbtD6lh8cGrHLWVGTw4fQqP9+Z9qaftG1ld0=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optionals enableManpages [
    "man"
  ]
  ++ lib.optionals finalAttrs.doCheck [
    "test"
  ];

  postUnpack = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals enableManpages [
    docutils # only for the man pages
  ];

  checkInputs = [
    python3Packages.python
    (lib.getBin openssl)
  ];

  configureFlags = [
    "--disable-dbus"
  ]
  ++ lib.optionals (!enableManpages) [
    "--disable-manual-pages"
  ];

  enableParallelBuilding = true;

  # override this to false if you don't want to build python3
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # prevent the `install-data-local` Makefile rule from running;
  # all it does is attempt to `mkdir` the `localstatedir`.
  preInstall = ''
    mkdir install-data-local
    substituteInPlace Makefile --replace \
      '$(MKDIR_P) -m 700 $(DESTDIR)$(daemon_storagedir)' \
      'true'
  '';

  postInstall = ''
    mkdir -p $doc/share/doc
    cp -a doc $doc/share/doc/iwd
    cp -a README AUTHORS TODO $doc/share/doc/iwd
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    mkdir -p $test/bin
    cp -a test/* $test/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/illiliti/eiwd/";
    description = "Fork of iwd (wifi daemon) which does not require dbus";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
})
