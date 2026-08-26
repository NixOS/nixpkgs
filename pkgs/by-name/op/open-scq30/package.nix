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
  cosmic-icons,
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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "Oppzippy";
    repo = "OpenSCQ30";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jvmgHAp4Et3VrUhZfNuFAA9r8n215kNB6Ux04HYC+KI=";
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

  cargoHash = "sha256-/dj2LBNcYcewt3Rhz82lZuoyCzaa/QC49CxfKoGfF6w=";

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

  # fix missing icons
  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${cosmic-icons}/share")
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
