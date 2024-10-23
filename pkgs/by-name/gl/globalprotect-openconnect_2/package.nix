{
  perl,
  jq,
  fetchFromGitHub,
  lib,
  openconnect,
  libsoup,
  webkitgtk_4_0,
  pkg-config,
  callPackage,
  rustPlatform,
  glib,
  atk,
  gdk-pixbuf,
  pango,
  cairo,
  harfbuzz,
  gtk3,
  zlib,
  vpnc-scripts,
  withGui ? false,
}:
let
  platforms = [
    "aarch64-linux"
    "x86_64-linux"
  ];
  maintainers = with lib.maintainers; [
    m1dugh
    binary-eater
  ];
  version = "2.3.9";
  pname = "globalprotect-openconnect";

  gpgui = callPackage ./gui.nix { inherit version platforms maintainers; };

in
rustPlatform.buildRustPackage {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-s+uCpNrwQvdIINLSIbtcCCBg469J2xtlyiwDYqtXrQs=";
  };

  nativeBuildInputs = [
    perl
    jq
    pkg-config
  ];

  buildInputs = [
    libsoup
    glib
    webkitgtk_4_0
    atk
    gdk-pixbuf
    pango
    cairo
    harfbuzz
    gtk3
    openconnect
    zlib
  ];

  NIX_CFLAGS_COMPILE = (map (pkg: "-I${pkg}/include") [ openconnect.dev ]);

  NIX_CFLAGS_LINK = (
    map (pkg: "-L${lib.getLib pkg}/lib") [
      openconnect
      zlib
    ]
  );

  cargoHash = "sha256-/KJM1JjFFI4aR1YwWI7k27QSPknPponTTazk5FG9HKc=";

  postPatch =
    let
      replacements = [
        "--replace-fail /usr/bin/gpclient $out/bin/gpclient"
        "--replace-fail /usr/bin/gpservice $out/bin/gpservice"
        "--replace-fail /usr/bin/gpgui-helper $out/bin/gpgui-helper"
        "--replace-fail /usr/bin/gpauth $out/bin/gpauth"
      ] ++ lib.optional withGui "--replace-fail /usr/bin/gpgui ${gpgui}/bin/gpgui";
    in
    ''
      substituteInPlace crates/common/src/vpn_utils.rs \
        --replace-fail /etc/vpnc/vpnc-script ${vpnc-scripts}/bin/vpnc-script

      substituteInPlace crates/gpapi/src/lib.rs \
        ${lib.strings.concatStringsSep " " replacements}
    '';

  postInstall =
    ''
      mkdir -p $out/share/applications/
      cp packaging/files/usr/share/applications/gpgui.desktop $out/share/applications/gpgui.desktop
    ''
    + lib.strings.optionalString withGui ''
      ln -s ${gpgui}/bin/gpgui $out/bin/
      ln -s ${gpgui}/share/icons/ $out/share/
      ln -s ${gpgui}/share/polkit-1/ $out/share/
    '';

  postFixup = ''
    substituteInPlace $out/share/applications/gpgui.desktop \
       --replace-fail /usr/bin/gpclient $out/bin/gpclient
  '';

  meta = {
    mainProgram = "gpclient";
    description = "GlobalProtect VPN client for Linux, written in Rust, based on OpenConnect and Tauri, supports SSO with MFA, Yubikey, and client certificate authentication";
    longDescription = ''
      The package includes both the executables for the cli version of
      globalprotect-openconnect_2 (gpclient and gpauth), and the executables
      for the gui version (same as before + gpservice and gpgui).
    '';

    license = with lib.licenses; if withGui then unfree else gpl3;

    homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
    inherit platforms;
  };
}
