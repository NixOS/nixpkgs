{
  perl,
  jq,
  fetchFromGitHub,
  lib,
  openconnect,
  libsoup,
  webkitgtk,
  pkg-config,
  vpnc-scripts,
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
}:
let
  version = "2.3.7";
  pname = "globalprotect-openconnect";
  gpgui = callPackage ./gui.nix { };

in
rustPlatform.buildRustPackage {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-Zr888II65bUjrbStZfD0AYCXKY6VdKVJHQhbKwaY3is=";
  };

  nativeBuildInputs = [
    perl
    jq
    openconnect
    libsoup
    webkitgtk
    pkg-config
  ];

  PKG_CONFIG_PATH = lib.strings.concatMapStringsSep ":" (pkg: "${pkg}/lib/pkgconfig/") [
    glib.dev
    libsoup.dev
    webkitgtk.dev
    atk.dev
    gdk-pixbuf.dev
    pango.dev
    cairo.dev
    harfbuzz.dev
    gtk3.dev
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

  cargoHash = "sha256-cdhhBUQASrnfjeJxkwx39vr/KHeQlBh0wMvw+Q7EK98=";

  postPatch = ''
        substituteInPlace crates/common/src/vpn_utils.rs \
        --replace-fail /etc/vpnc/vpnc-script ${lib.getExe vpnc-scripts} \
        --replace-fail /usr/libexec/openconnect/hipreport.sh ${openconnect}/libexec/openconnect/hipreport.sh

    substituteInPlace crates/gpapi/src/lib.rs \
        --replace-fail /usr/bin/gpclient $out/bin/gpclient \
        --replace-fail /usr/bin/gpservice $out/bin/gpservice \
        --replace-fail /usr/bin/gpgui-helper $out/bin/gpgui-helper \
        --replace-fail /usr/bin/gpgui ${gpgui}/bin/gpgui \
        --replace-fail /usr/bin/gpauth $out/bin/gpauth
  '';

  postInstall = ''
    mkdir -p $out/
    ln -s ${gpgui}/bin/gpgui $out/bin/
    ln -s ${gpgui}/share/ $out/share
  '';

  meta = {
    mainProgram = "gpclient";
    description = "A GlobalProtect VPN client for Linux, written in Rust, based on OpenConnect and Tauri, supports SSO with MFA, Yubikey, and client certificate authentication, etc.";
    licences = lib.licences.gpl3;
    homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
    maintainers = [ lib.maintainers.m1dugh ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
