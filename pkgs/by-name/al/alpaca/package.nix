{
  lib,
  python3Packages,
  fetchFromGitHub,
  appstream,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gtksourceview5,
  xdg-utils,
  ollama,
  vte-gtk4,
  libspelling,
  gst_all_1,
  pipewire,

  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "alpaca";
  version = "7.0.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    tag = version;
    hash = "sha256-2p6ANlQQ1EWs7FYLPP9URg4m40CrC7A8NwZ/TdP2JPA=";
  };

  nativeBuildInputs = [
    appstream
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    vte-gtk4
    libspelling
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    pipewire
  ];

  dependencies =
    with python3Packages;
    [
      pygobject3
      requests
      pillow
      html2text
      youtube-transcript-api
      pydbus
      odfpy
      pyicu
      matplotlib
      openai
      markitdown
      opencv4
      duckduckgo-search
    ]
    ++ lib.flatten (builtins.attrValues optional-dependencies);

  optional-dependencies = {
    speech-to-text = [
      python3Packages.kokoro
      python3Packages.openai-whisper
      python3Packages.pyaudio
      python3Packages.sounddevice
      python3Packages.spacy-models.en_core_web_sm
    ];
  };

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        xdg-utils
        ollama
      ]
    }"
    # Declared but not used in src/window.py, for later reference
    # https://github.com/flatpak/flatpak/issues/3229
    "--set FLATPAK_DEST ${placeholder "out"}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ollama client made with GTK4 and Adwaita";
    longDescription = ''
      To run Alpaca with GPU acceleration enabled, simply override it:
      ```nix
      pkgs.alpaca.override {
        ollama = pkgs.ollama-cuda;
      }
      ```
      Or using `pkgs.ollama-rocm` for AMD GPUs.
    '';
    homepage = "https://jeffser.com/alpaca";
    license = lib.licenses.gpl3Plus;
    mainProgram = "alpaca";
    maintainers = with lib.maintainers; [
      aleksana
      Gliczy
    ];
    platforms = lib.platforms.unix;
  };
}
