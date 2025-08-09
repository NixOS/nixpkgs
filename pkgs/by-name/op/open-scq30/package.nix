{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  cargo-make,
}:

rustPlatform.buildRustPackage rec {
  pname = "open-scq30";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Oppzippy";
    repo = "OpenSCQ30";
    rev = "v${version}";
    hash = "sha256-DL2hYm1j27K0nnBvE3iGnguqm0m1k56bkuG+6+u4u4c=";
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
  ];

  cargoHash = "sha256-3K+/CpTGWSjCRa2vOEcDvLIiZMdntugIqnzkXF4wkng=";

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
    description = "Cross platform application for controlling settings of Soundcore headphones";
    homepage = "https://github.com/Oppzippy/OpenSCQ30";
    changelog = "https://github.com/Oppzippy/OpenSCQ30/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "open-scq30";
  };
}
