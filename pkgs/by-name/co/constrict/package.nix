{
  lib,
  python3Packages,
  fetchFromGitLab,
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
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "constrict";
  version = "26.2";
  pyproject = false; # Built with meson

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Constrict";
    tag = finalAttrs.version;
    hash = "sha256-SkfutiBi0Y7gNx5PyTaSzVw/5rU/0ULxbtf2606i2wA=";
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Compresses your videos to your chosen file size";
    homepage = "https://gitlab.gnome.org/World/Constrict";
    changelog = "https://gitlab.gnome.org/World/Constrict/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "constrict";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
