{
  lib,
  rustPlatform,
  glib-networking,
  stdenv,
  gpauth,
  makeWrapper,
  autoconf,
  automake,
  libtool,
  openssl,
  perl,
  pkg-config,
  vpnc-scripts,
  glib,
  pango,
  cairo,
  atk,
  gtk3,
  libxml2,
  p11-kit,
  lz4,
  gnutls,
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

    # used to build vendored openconnect
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    gpauth
    openssl
    glib-networking
    glib
    pango
    cairo
    atk
    gtk3

    # used for vendored openconnect
    libxml2
    lz4
    p11-kit
    gnutls
  ];

  postPatch = ''
    substituteInPlace crates/openconnect/src/vpn_utils.rs \
      --replace-fail /etc/vpnc/vpnc-script ${vpnc-scripts}/bin/vpnc-script \
      --replace-fail /usr/libexec/gpclient/hipreport.sh $out/libexec/gpclient/hipreport.sh

    substituteInPlace crates/common/src/constants.rs \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient \
      --replace-fail /usr/bin/gpservice $out/bin/gpservice \
      --replace-fail /usr/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /opt/homebrew/ $out/
  '';

  postInstall = ''
    cp -r packaging/files/usr/libexec $out/libexec

    substituteInPlace $out/libexec/gpclient/hipreport.sh \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r packaging/files/usr/lib $out/lib
    substituteInPlace $out/lib/NetworkManager/dispatcher.d/pre-down.d/gpclient.down \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient
  '';

  postFixup = ''
    wrapProgram "$out/bin/gpclient" \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules
  '';
}
