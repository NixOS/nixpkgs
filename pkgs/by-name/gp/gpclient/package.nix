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
}:

rustPlatform.buildRustPackage {
  pname = "gpclient";

  inherit (gpauth) version src meta;

  buildAndTestSubdir = "apps/gpclient";
  cargoHash = "sha256-aanC0iwitvpKWCZSyaGVIkrWo/Hi1gjS19t3PfW+w4U=";

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
