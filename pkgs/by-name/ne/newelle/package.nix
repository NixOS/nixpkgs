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
  glib-networking,
  webkitgtk_6_0,
  lsb-release,
  bash,
  ffmpeg,
  nix-update-script,
}:

let
  version = "1.6.1";
in
python3Packages.buildPythonApplication {
  pname = "newelle";
  inherit version;
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "qwersyk";
    repo = "Newelle";
    tag = version;
    hash = "sha256-myVEdqIcAKx+RAoy3h4rmhW+vYAlBwnXTa8uiwvLfiY=";
  };

  postPatch = ''
    substituteInPlace src/utility/pip.py \
      --replace-fail "global PIP_INSTALLED" "return None"
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
    webkitgtk_6_0
    glib-networking
  ];

  dependencies = with python3Packages; [
    pygobject3
    libxml2
    cssselect
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
    faiss-cpu
    llama-index-core
    llama-index-readers-file
    llama-index-vector-stores-faiss
    google-genai
    anthropic
    mcp
    ddgs
    markdownify
    huggingface-hub
  ];

  postInstallCheck = ''
    mesonCheckPhase
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      lsb-release
      bash
      ffmpeg
    ])
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/qwersyk/Newelle";
    description = "Ultimate Virtual Assistant";
    mainProgram = "newelle";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      michaelAllen
    ];
  };
}
