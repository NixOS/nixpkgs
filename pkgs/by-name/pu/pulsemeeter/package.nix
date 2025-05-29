{
  lib,
  python3,
  fetchFromGitHub,
  libappindicator,
  libpulseaudio,
  gobject-introspection,
  wrapGAppsHook4,
  ladspaPlugins,
  bash,
# noise-suppression-for-voice,
# pulse-vumeter,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pulsemeeter";
  version = "1.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theRealCarneiro";
    repo = "pulsemeeter";
    tag = "v${version}";
    hash = "sha256-QTXVE5WvunsjLS8I1rgX34BW1mT1UY+cRxURwXiQp5A=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    bash
    libappindicator
    libpulseaudio
  ];

  dependencies = with python3.pkgs; [
    pulsectl
    pygobject3
  ];

  pythonImportsCheck = [
    "pulsemeeter"
  ];

  dontWrapGApps = true;
  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postPatch = ''
    substituteInPlace scripts/pmctl \
      --replace-fail '/usr/lib/ladspa' '${ladspaPlugins}/lib/ladspa' \
      --replace-fail " '/usr/local/lib/ladspa'" ""
  '';

  meta = {
    description = "Replicating voicemeeter routing functionalities in linux with pulseaudio";
    homepage = "https://github.com/theRealCarneiro/pulsemeeter";
    changelog = "https://github.com/theRealCarneiro/pulsemeeter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "pulsemeeter";
  };
}
