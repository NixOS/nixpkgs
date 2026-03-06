{
  lib,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  wrapGAppsHook4,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  glib,
  gtk4,
  libadwaita,
  libGL,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cine";
  version = "1.0.9";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "diegopvlk";
    repo = "Cine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aw+M1wCGSbRRmKKcgyM4luEr0WtPLw/v7SqBE1B5H9U=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    appstream
  ];

  buildInputs = [
    gettext
    glib
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    mpv
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]})
  '';

  meta = {
    description = "Video Player for Linux";
    homepage = "https://github.com/diegopvlk/Cine";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pancaek ];
    mainProgram = "cine";
    platforms = lib.platforms.linux;
  };
})
