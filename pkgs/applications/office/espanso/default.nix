{ lib
, fetchFromGitHub
, rustPlatform
, cargo-make
, pkg-config
, extra-cmake-modules
, dbus
, libX11
, libXi
, libXtst
, libnotify
, libxkbcommon
, openssl
, xclip
, xdotool
, setxkbmap
, wl-clipboard
, wxGTK32
, makeWrapper
, stdenv
, AppKit
, Cocoa
, Foundation
, waylandSupport ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = pname;
    rev = "v${version}";
    sha256 = "06wzrjdvssixgd9rnrv4cscbfiyvp5pjpnrih48r0ral3pj2hdg5";
  };

  cargoSha256 = "sha256-U2ccF7DM16TtX3Kc4w4iNV4WsswHJ0FpO3+sWCL1Li8=";

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
    makeWrapper
    cargo-make
    wxGTK32
  ];

  NO_X11 = lib.optionals waylandSupport "true";

  buildInputs = [
    libXi
    libXtst
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    libnotify
    libX11
    libxkbcommon
    xclip
    xdotool
    wxGTK32
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
  ] ++ lib.optionals waylandSupport [
    wl-clipboard
  ];

  # Some tests require networking
  doCheck = false;

  preBuild = lib.optionalString waylandSupport ''
    export NO_X11=true
  '';

  postInstall = ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath [ libnotify xclip wl-clipboard setxkbmap ]}
  '';

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kimat thehedgeh0g ];
    platforms = platforms.unix;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
