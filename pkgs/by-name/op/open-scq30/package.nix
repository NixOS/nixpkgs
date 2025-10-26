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
  libx11,
  libxcursor,
  libxi,
  autoPatchelfHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "open-scq30";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "Oppzippy";
    repo = "OpenSCQ30";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XBK7KxuksQoYZs/uVkh6+8S20G05W9ftK9pviUFNJ8s=";
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
    libx11
    libxcursor
    libxi
  ];

  cargoHash = "sha256-P4r1MoFCkG80X0dJ1MpmjgedcpQ/HDTC3XikNUDKRaQ=";

  env.INSTALL_PREFIX = placeholder "out";

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

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Cross platform application for controlling settings of Soundcore headphones";
    homepage = "https://github.com/Oppzippy/OpenSCQ30";
    changelog = "https://github.com/Oppzippy/OpenSCQ30/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "open-scq30";
  };
})
