{
  rustPlatform,
  glib-networking,
  gpauth,
  makeWrapper,
  openconnect,
  openssl,
  perl,
  pkg-config,
  vpnc-scripts,
  glib,
  pango,
  cairo,
  atk,
  gtk3,
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
  ];
  buildInputs = [
    gpauth
    openconnect
    openssl
    glib-networking
    glib
    pango
    cairo
    atk
    gtk3
  ];

  preConfigure = ''
    substituteInPlace crates/gpapi/src/lib.rs \
      --replace-fail /usr/bin/gpauth ${gpauth}/bin/gpauth
    substituteInPlace crates/common/src/vpn_utils.rs \
      --replace-fail /usr/sbin/vpnc-script ${vpnc-scripts}/bin/vpnc-script
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp packaging/files/usr/share/applications/gpgui.desktop $out/share/applications/gpgui.desktop
  '';

  preFixup = ''
    wrapProgram "$out/bin/gpclient" \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/gpgui.desktop \
      --replace-fail /usr/bin/gpclient gpclient
  '';
}
