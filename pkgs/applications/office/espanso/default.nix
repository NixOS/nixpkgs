{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, extra-cmake-modules
, libX11
, libXi
, libXtst
, libnotify
, openssl
, xclip
, xdotool
, makeWrapper
, stdenv
, AppKit
, Cocoa
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q47r43midkq9574gl8gdv3ylvrnbhdc39rrw4y4yk6jbdf5wwkm";
  };

  cargoSha256 = "0ba5skn5s6qh0blf6bvivzvqc2l8v488l9n3x98pmf6nygrikfdb";

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXtst
    libXi
    libnotify
    xclip
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    xdotool
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
  ];

  # Some tests require networking
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath [ libnotify xclip ]}
  '';

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kimat ];
    platforms = platforms.unix;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
