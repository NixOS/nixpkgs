{
  lib,
  python3,
  fetchFromGitHub,
  qt5,
  wrapGAppsHook3,
  gobject-introspection,
  libjack2,
  ola,
  nix-update-script,
}:
let
  version = "0.6.4";
in
python3.pkgs.buildPythonApplication {
  pname = "linux-show-player";
  inherit version;
  pyproject = true;

  # 3.13 is unsupported for now
  disabled = with python3.pkgs; pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "FrancescoCeruti";
    repo = "linux-show-player";
    tag = "v${version}";
    hash = "sha256-QgsgG+SeHT9bZgSkpo5AKpm/YIifn7qRfe/C3paMS5o=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    wrapGAppsHook3

    gobject-introspection
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    appdirs
    falcon
    jack-client
    mido
    pygobject3
    pyqt5
    python-rtmidi
    requests
    sortedcontainers
    humanize
    pyalsa
    pyliblo

    # Undocumented dependencies. *sigh*
    gst-python
    ola # Using Python bindings
  ];

  buildInputs = [ libjack2 ];

  pythonRemoveDeps = [
    "pyqt5-qt5"
    "pyliblo3"
  ];

  dontWrapQtApps = true;
  dontWrapGApps = true;

  makeWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libjack2 ]}"''
    "\${qtWrapperArgs[@]}"
    "\${gappsWrapperArgs[@]}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cue player designed for stage productions";
    changelog = "https://github.com/FrancescoCeruti/linux-show-player/releases/tag/v${version}";
    homepage = "https://linux-show-player.org/";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.linux;
    mainProgram = "linux-show-player";
  };
}
