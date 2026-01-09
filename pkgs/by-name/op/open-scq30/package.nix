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
  just,
  sqlite,
  wayland,
  libxkbcommon,
  libGL,
  libX11,
  libXcursor,
  libXi,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "open-scq30";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Oppzippy";
    repo = "OpenSCQ30";
    rev = "v${version}";
    hash = "sha256-2dvdR9dd0VaMlPOacTMN1BzDtIdFfd7sNVpWFuQp8j8=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    wrapGAppsHook4
    just
    autoPatchelfHook
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    sqlite
    libxkbcommon
  ];

  # Wayland and X11 libs are required at runtime since winit uses dlopen
  runtimeDependencies = [
    wayland
    libxkbcommon
    libGL
    libX11
    libXcursor
    libXi
  ];

  cargoHash = "sha256-2iPazXFpa2SnI8LTm/BnttIQ+sYDUPRNHTFEw6jBMuQ=";

  INSTALL_PREFIX = placeholder "out";

  # Requires headphones
  doCheck = false;

  postPatch = ''
    patchShebangs ./gui/scripts ./cli/scripts ./scripts
  '';

  buildPhase = ''
    just build-cli
    just build-gui
  '';

  installPhase = ''
    just install ${placeholder "out"}
  '';

  meta = {
    description = "Cross platform application for controlling settings of Soundcore headphones";
    homepage = "https://github.com/Oppzippy/OpenSCQ30";
    changelog = "https://github.com/Oppzippy/OpenSCQ30/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "open-scq30";
  };
}
