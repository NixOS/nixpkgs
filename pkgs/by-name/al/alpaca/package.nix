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
  nix-update-script,
  blueprint-compiler,
  libportal,
  webkitgtk_6_0,
  pipewire,
  glib-networking,
  bash,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      bibtexparser = self.bibtexparser_2;
    }
  );
in
pythonPackages.buildPythonApplication rec {
  pname = "alpaca";
  version = "9.0.5";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    tag = version;
    hash = "sha256-fN4WKYpsgkYIhPLU7Ckcroo2S0lzX5cGN6uvYS4lG50=";
  };

  postPatch = ''
    substituteInPlace src/widgets/activities/terminal.py \
      --replace-fail "['bash', '-c', ';\n'.join(self.prepare_script())]," "['${bash}/bin/bash', '-c', ';\n'.join(self.prepare_script())],"
  '';

  nativeBuildInputs = [
    appstream
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    vte-gtk4
    libspelling
    libportal
    webkitgtk_6_0
    pipewire # pipewiresrc
    glib-networking
  ];

  dependencies =
    with pythonPackages;
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
      gst-python
      opencv4
      zstandard
    ]
    ++ lib.concatAttrValues optional-dependencies;

  optional-dependencies = with pythonPackages; {
    speech-to-text = [
      openai-whisper
      pyaudio
    ];
    text-to-speech = [
      kokoro
      sounddevice
      spacy-models.en_core_web_sm
    ];
    image-tools = [ rembg ];
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
      For a vendor agnostic solution, use: `pkgs.ollama-vulkan`.
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
