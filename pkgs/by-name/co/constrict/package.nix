{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  libglycin,
  libglycin-gtk4,
  libva-utils,
  ffmpeg,
  gst-thumbnailers,
  glycin-loaders,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "constrict";
  version = "25.12.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Wartybix";
    repo = "Constrict";
    tag = finalAttrs.version;
    hash = "sha256-ZSiBlejNFakz+/3qj3n+ekB5l9JOk3MiQ8PRZOdxtLQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libglycin
    libglycin-gtk4
    glycin-loaders
  ];

  dependencies = [
    python3Packages.pygobject3
  ];

  # Search for use of subprocess
  runtimeDeps = [
    libva-utils
    ffmpeg
    gst-thumbnailers
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}
    )
  '';

  meta = {
    description = "Compresses your videos to your chosen file size";
    homepage = "https://github.com/Wartybix/Constrict";
    changelog = "https://github.com/Wartybix/Constrict/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "constrict";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
