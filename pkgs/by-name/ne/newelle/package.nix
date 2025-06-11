{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gobject-introspection,
  desktop-file-utils,
  libadwaita,
  vte-gtk4,
  gsettings-desktop-schemas,
  gtksourceview5,
  lsb-release,
  bash,
  ffmpeg,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "newelle";
  version = "0.9.8";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "qwersyk";
    repo = "Newelle";
    tag = version;
    hash = "sha256-VyUng/ZX8+wInRX705IWdBgTbX439R60h62ONdpZ0+8=";
  };

  postPatch = ''
    substituteInPlace src/utility/pip.py \
      --replace-fail "# Manage pip path locking" "return None"
  '';

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    pkg-config
  ];

  buildInputs = [
    libadwaita
    vte-gtk4
    gsettings-desktop-schemas
    gtksourceview5
  ];

  dependencies = with python3Packages; [
    pygobject3
    libxml2
    pydub
    gtts
    speechrecognition
    numpy
    matplotlib
    pylatexenc
    pyaudio
    pip-install-test
    newspaper3k
    tiktoken
    openai
    ollama
    llama-index-core
    llama-index-readers-file
    google-genai
    anthropic
  ];

  strictDeps = true;

  postInstallCheck = ''
    mesonCheckPhase
  '';

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        lsb-release
        bash
        ffmpeg
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/qwersyk/Newelle";
    description = "Ultimate Virtual Assistant";
    mainProgram = "newelle";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
