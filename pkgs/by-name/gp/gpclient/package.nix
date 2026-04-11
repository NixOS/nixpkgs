{
  lib,
  rustPlatform,
  stdenv,
  atk,
  autoconf,
  automake,
  cairo,
  glib,
  glib-networking,
  gnutls,
  gpauth,
  gtk3,
  libtool,
  libxml2,
  lz4,
  makeBinaryWrapper,
  openssl,
  p11-kit,
  pango,
  perl,
  pkg-config,
  vpnc-scripts,
}:

rustPlatform.buildRustPackage {
  pname = "gpclient";

  inherit (gpauth)
    cargoHash
    meta
    src
    version
    ;

  buildAndTestSubdir = "apps/gpclient";

  nativeBuildInputs = [
    makeBinaryWrapper
    perl
    pkg-config

    # used to build vendored openconnect
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    glib
    glib-networking
    gpauth
    openssl

    # used for vendored openconnect
    gnutls
    libxml2
    lz4
    p11-kit
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    atk
    cairo
    gtk3
    pango
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
