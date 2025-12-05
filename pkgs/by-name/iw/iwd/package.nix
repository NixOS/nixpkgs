{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  ell,
  coreutils,
  docutils,
  readline,
  openssl,
  python3Packages,
  gitUpdater,
}:

let
  # fix segfault in iwctl with readline-8.3
  # https://lists.gnu.org/archive/html/bug-readline/2025-07/msg00007.htmlP
  readline-patch = fetchpatch {
    url = "https://lists.gnu.org/archive/html/bug-readline/2025-07/txtmA7rksnmmi.txt";
    hash = "sha256-QSS1GUJ2i/bF2ksvUtw27oqFHuTHALi+7QwxMFt9ZaM=";
    stripLen = 2;
  };

  myreadline = (
    readline.overrideAttrs (
      _final: prev: {
        patches = (prev.patches or [ ]) ++ [ readline-patch ];
      }
    )
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "iwd";
  version = "3.10";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    tag = finalAttrs.version;
    hash = "sha256-qzqBNGy67/VvRZh7n0W2ZPYwoyX/lP6k1sF57lL6v7c=";
  };

  patches = [
    # Remove dbus config referencing the netdev group, which we don't have.
    # Users are advised to use the wheel group instead.
    ./no_netdev_group.diff
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ]
  ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "test";
  separateDebugInfo = true;

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    ell
    python3Packages.python
    myreadline
  ];

  nativeCheckInputs = [ openssl ];

  # wrapPython wraps the scripts in $test. They pull in gobject-introspection,
  # which doesn't cross-compile.
  pythonPath = lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    python3Packages.dbus-python
    python3Packages.pygobject3
  ];

  configureFlags = [
    "--enable-external-ell"
    "--enable-wired"
    "--localstatedir=/var/"
    "--with-dbus-busdir=${placeholder "out"}/share/dbus-1/system-services/"
    "--with-dbus-datadir=${placeholder "out"}/share/"
    "--with-systemd-modloaddir=${placeholder "out"}/etc/modules-load.d/" # maybe
    "--with-systemd-unitdir=${placeholder "out"}/lib/systemd/system/"
    "--with-systemd-networkdir=${placeholder "out"}/lib/systemd/network/"
  ];

  postUnpack = ''
    mkdir -p iwd/ell
    ln -s ${ell.src}/ell/useful.h iwd/ell/useful.h
    ln -s ${ell.src}/ell/asn1-private.h iwd/ell/asn1-private.h
    patchShebangs .
  '';

  doCheck = true;

  postInstall = ''
    mkdir -p $doc/share/doc
    cp -a doc $doc/share/doc/iwd
    cp -a README AUTHORS TODO $doc/share/doc/iwd
  ''
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p $test/bin
    cp -a test/* $test/bin/
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/system-services/net.connman.ead.service \
      --replace-fail /bin/false ${coreutils}/bin/false
    substituteInPlace $out/share/dbus-1/system-services/net.connman.iwd.service \
      --replace-fail /bin/false ${coreutils}/bin/false
  '';

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
  };

  meta = {
    homepage = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    description = "Wireless daemon for Linux";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      dtzWill
      fpletz
    ];
  };
})
