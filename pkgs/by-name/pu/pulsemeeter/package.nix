{
  lib,
  python3Packages,
  fetchFromGitHub,
  libpulseaudio,
  libappindicator,
  gobject-introspection,
  wrapGAppsHook3,
  callPackage,
  bash,
}:
python3Packages.buildPythonApplication rec {
  pname = "pulsemeeter";
  version = "1.2.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "theRealCarneiro";
    repo = "pulsemeeter";
    tag = "v${version}";
    hash = "sha256-QTXVE5WvunsjLS8I1rgX34BW1mT1UY+cRxURwXiQp5A=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pulsectl
    pygobject3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    libappindicator
    libpulseaudio
    bash
  ];

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
  ];

  dontWrapGApps = true;

  passthru.tests.version = callPackage ./version-test.nix { inherit version; };

  meta = {
    description = "Frontend of pulseaudio's routing capabilities, mimicking voicemeeter's workflow";
    license = lib.licenses.mit;
    homepage = "https://github.com/theRealCarneiro/pulsemeeter";
    maintainers = with lib.maintainers; [
      therobot2105
    ];
    mainProgram = "pulsemeeter";
    platforms = lib.platforms.linux;
  };
}
