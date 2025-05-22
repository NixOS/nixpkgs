{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  docutils,
  gobject-introspection,
  desktop-file-utils,
  libadwaita,
  vte-gtk4,
  gsettings-desktop-schemas,
  gtksourceview5,
  lsb-release,
  bash,
  wget,
  ffmpeg,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "newelle";
  version = "0.9.6";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "qwersyk";
    repo = "Newelle";
    tag = version;
    hash = "sha256-NQujsdmrocYsnWCj5nyBUWg6/GolSBsoMWbazeUHr5E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    docutils
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
    tiktoken
    openai
    ollama
    llama-index-core
    llama-index-readers-file
    pip-install-test
    newspaper3k
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
        wget
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
