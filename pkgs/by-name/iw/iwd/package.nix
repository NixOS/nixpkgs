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

stdenv.mkDerivation (finalAttrs: {
  pname = "iwd";
  version = "3.12";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    tag = finalAttrs.version;
    hash = "sha256-78Zw/i2dXecvC+DDSunPlUzqJj0FFYf7Sm6iN5VXBbA=";
  };

  patches = [
    # Remove dbus config referencing the netdev group, which we don't have.
    # Users are advised to use the wheel group instead.
    ./no_netdev_group.diff

    # Fixes for exploitable memory-safety bugs reported in
    # https://abhinavagarwal07.github.io/posts/iwd-rrm-stack-overflow/
    (fetchpatch {
      name = "rrm-fix-stack-buffer-overflow-in-rrm_report_beacon_results.patch";
      url = "https://raw.githubusercontent.com/abhinavagarwal07/iwd-security-poc/1d646278412ef446f30cb58025590e6ff5945cb0/patches/0001-rrm-fix-stack-buffer-overflow-in-rrm_report_beacon_r.patch";
      hash = "sha256-t7f4vrS8Ns0BUt8UxS+62T+xWDZaA/t5A0cnXWm00ZU=";
    })
    (fetchpatch {
      name = "ie-fix-off-by-one-in-he-capabilities-channel-width-set.patch";
      url = "https://raw.githubusercontent.com/abhinavagarwal07/iwd-security-poc/1d646278412ef446f30cb58025590e6ff5945cb0/patches/0002-ie-fix-off-by-one-in-HE-Capabilities-Channel-Width-S.patch";
      hash = "sha256-142lowS9YtOGwfRqryxxGnzcNZrz72tIOhVZhlo3fMY=";
    })
    (fetchpatch {
      name = "ft-fix-mde_equal-self-comparison-and-type-mismatch.patch";
      url = "https://raw.githubusercontent.com/abhinavagarwal07/iwd-security-poc/1d646278412ef446f30cb58025590e6ff5945cb0/patches/0003-ft-fix-mde_equal-self-comparison-and-type-mismatch.patch";
      hash = "sha256-Qdm8eAw3tbH/wDWvmWIkKxMQ2m16o+VvEPYaKXBgAAw=";
    })
    (fetchpatch {
      name = "ie-fix-uint8_t-underflow-in-fte-sub-element-parser.patch";
      url = "https://raw.githubusercontent.com/abhinavagarwal07/iwd-security-poc/1d646278412ef446f30cb58025590e6ff5945cb0/patches/0004-ie-fix-uint8_t-underflow-in-FTE-sub-element-parser.patch";
      hash = "sha256-6At7PUXoORM++9ndIzxTTRu7V09+D31DrdMNLt1EtOc=";
    })
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
    readline
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
      fpletz
    ];
  };
})
