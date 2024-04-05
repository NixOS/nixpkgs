{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, wrapGAppsHook4
, cairo
, dbus
, gdk-pixbuf
, glib
, gtk4
, libadwaita
, pango
, stdenv
, darwin
, cargo-make
}:

rustPlatform.buildRustPackage rec {
  pname = "open-scq30";
  version = "1.10.6";

  src = fetchFromGitHub {
    owner = "Oppzippy";
    repo = "OpenSCQ30";
    rev = "v${version}";
    hash = "sha256-qYWLf0ns4YSq+yAspVTMvKQi861iUMJar2wjqm+BV/0=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    wrapGAppsHook4
    cargo-make
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
  ];

  cargoHash = "sha256-BQLNm+yyimBh7WomrccdQ2lvrQzCNXf4MEa1LlPhck0=";

  INSTALL_PREFIX = placeholder "out";

  # Requires headphones
  doCheck = false;

  buildPhase = ''
    cargo make --profile release build
  '';

  installPhase = ''
    cargo make --profile release install
  '';

  meta = with lib; {
    description = "Cross platform application for controlling settings of Soundcore headphones.";
    homepage = "https://github.com/Oppzippy/OpenSCQ30";
    changelog = "https://github.com/Oppzippy/OpenSCQ30/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "open-scq30";
  };
}
