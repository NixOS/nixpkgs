{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  libadwaita,
  copyDesktopItems,
  makeDesktopItem,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pipewire-control-center";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "knightinfected";
    repo = "PipeWireController";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yoM4tr3yJEt2QlTmYAWiTm28SEZ5LWk5JrA6YVQ+d8k=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    numpy
    pycairo
    pygobject3
    soundfile
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "io.github.knightinfected.PipeWireControlCenter";
      desktopName = "PipeWire Controller";
      comment = "Configure PipeWire, filter chains and HRIR virtual surround without editing files";
      exec = "pipewire-control-center";
      icon = "audio-card";
      categories = [
        "AudioVideo"
        "Audio"
        "Settings"
      ];
      keywords = [
        "pipewire"
        "audio"
        "surround"
        "hrir"
        "equalizer"
        "filter"
        "pwcc"
      ];
      startupWMClass = "io.github.knightinfected.PipeWireControlCenter";
    })
  ];

  pythonImportsCheck = [
    "pwctl"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTK4/libadwaita audio control center for PipeWire";
    longDescription = ''
      A GUI control center for PipeWire providing audio management, signal paths,
      virtual devices, a live patchbay, parametric equalizer, performance monitoring,
      filter chains, microphone cleanup (echo/noise reduction), HRIR virtual surround,
      routing snapshots, per-app policies, and LADSPA/LV2 effect inserts.
    '';
    homepage = "https://github.com/knightinfected/PipeWireController";
    changelog = "https://github.com/knightinfected/PipeWireController/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arison ];
    mainProgram = "pipewire-control-center";
  };
})
