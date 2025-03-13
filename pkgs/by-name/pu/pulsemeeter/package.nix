{
  lib,
  python3,
  fetchFromGitHub,
  libappindicator,
  libpulseaudio,
  gobject-introspection,
  wrapGAppsHook4,
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

  meta = {
    description = "Replicating voicemeeter routing functionalities in linux with pulseaudio";
    homepage = "https://github.com/theRealCarneiro/pulsemeeter";
    changelog = "https://github.com/theRealCarneiro/pulsemeeter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "pulsemeeter";
  };
}
