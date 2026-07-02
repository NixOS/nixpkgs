{
  cava,
  desktop-file-utils,
  fetchFromGitHub,
  gobject-introspection,
  gst_all_1,
  gtk4,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cavasik";
  version = "3.2.0";

  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "TheWisker";
    repo = "Cavasik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O8rFtqzmDktXKF3219RAo1yxqjfPm1qkHhAyoT7N8AU=";
  };

  postPatch = ''
    substituteInPlace src/cava.py \
      --replace-fail '"cava"' '"${lib.getExe cava}"'
  '';

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    pycairo
    pydbus
    pygobject3
  ];

  checkPhase = ''
    runHook preCheck

    meson test --print-errorlog

    runHook postCheck
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]})
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Audio visualizer based on CAVA with extended capabilities";
    mainProgram = "cavasik";
    homepage = "https://github.com/TheWisker/Cavasik";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ starryreverie ];
  };
})
