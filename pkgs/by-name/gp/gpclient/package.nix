{
<<<<<<< HEAD
  lib,
  rustPlatform,
  glib-networking,
  stdenv,
  gpauth,
  makeWrapper,
  autoconf,
  automake,
  libtool,
=======
  rustPlatform,
  glib-networking,
  gpauth,
  makeWrapper,
  openconnect,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  openssl,
  perl,
  pkg-config,
  vpnc-scripts,
  glib,
  pango,
  cairo,
  atk,
  gtk3,
<<<<<<< HEAD
  libxml2,
  p11-kit,
  lz4,
  gnutls,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage {
  pname = "gpclient";

  inherit (gpauth)
    src
    version
    cargoHash
    meta
    ;

  buildAndTestSubdir = "apps/gpclient";

  nativeBuildInputs = [
    perl
    makeWrapper
    pkg-config
<<<<<<< HEAD

    # used to build vendored openconnect
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    gpauth
=======
  ];
  buildInputs = [
    gpauth
    openconnect
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    openssl
    glib-networking
    glib
    pango
    cairo
    atk
    gtk3
<<<<<<< HEAD

    # used for vendored openconnect
    libxml2
    lz4
    p11-kit
    gnutls
  ];

  postPatch = ''
    substituteInPlace crates/common/src/constants.rs \
      --replace-fail /usr/bin/gpauth ${gpauth}/bin/gpauth
    substituteInPlace crates/openconnect/src/vpn_utils.rs \
      --replace-fail /usr/sbin/vpnc-script ${vpnc-scripts}/bin/vpnc-script
    substituteInPlace packaging/files/usr/share/applications/gpgui.desktop \
      --replace-fail /usr/bin/gpclient gpclient
  '';

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
=======
  ];

  preConfigure = ''
    substituteInPlace crates/gpapi/src/lib.rs \
      --replace-fail /usr/bin/gpauth ${gpauth}/bin/gpauth
    substituteInPlace crates/common/src/vpn_utils.rs \
      --replace-fail /usr/sbin/vpnc-script ${vpnc-scripts}/bin/vpnc-script
  '';

  postInstall = ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mkdir -p $out/share/applications
    cp packaging/files/usr/share/applications/gpgui.desktop $out/share/applications/gpgui.desktop
  '';

  preFixup = ''
    wrapProgram "$out/bin/gpclient" \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules
  '';
<<<<<<< HEAD
=======

  postFixup = ''
    substituteInPlace $out/share/applications/gpgui.desktop \
      --replace-fail /usr/bin/gpclient gpclient
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
