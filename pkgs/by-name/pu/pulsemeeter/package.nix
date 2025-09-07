{
  lib,
  python3Packages,
  fetchFromGitHub,
  libappindicator,
  gobject-introspection,
  wrapGAppsHook4,
  callPackage,
  bash,
  pipewire,
  gtk4,
}:
python3Packages.buildPythonApplication rec {
  pname = "pulsemeeter";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theRealCarneiro";
    repo = "pulsemeeter";
    tag = "v${version}";
    hash = "sha256-hmQI+E6WmYOK7oN7zTmshFZgJ0UiN2KdZ6ZiXwxRpNs=";
  };

  build-system = with python3Packages; [
    setuptools
    babel
  ];

  dependencies = with python3Packages; [
    pygobject3
    pydantic
    pulsectl
    pulsectl-asyncio
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    libappindicator
    pipewire
    bash
    gtk4
  ];

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
  ];

  dontWrapGApps = true;

  pythonImportsCheck = [ "pulsemeeter" ];

  passthru.tests.version = callPackage ./version-test.nix { inherit version; };

  meta = {
    description = "Pulseaudio and pipewire audio mixer inspired by voicemeeter";
    license = lib.licenses.mit;
    homepage = "https://github.com/theRealCarneiro/pulsemeeter";
    maintainers = with lib.maintainers; [
      therobot2105
    ];
    mainProgram = "pulsemeeter";
    platforms = lib.platforms.linux;
  };
}
