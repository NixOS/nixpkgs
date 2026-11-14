{
  lib,
  python3Packages,
  fetchFromGitHub,
  appstream,
  bash,
  blueprint-compiler,
  desktop-file-utils,
  glib-networking,
  gobject-introspection,
  gtksourceview5,
  libadwaita,
  libportal,
  libspelling,
  meson,
  ninja,
  nix-update-script,
  ollama,
  pipewire,
  pkg-config,
  vte-gtk4,
  webkitgtk_6_0,
  wrapGAppsHook4,
  xdg-utils,
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
  version = "9.2.5";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    tag = version;
    hash = "sha256-tKbxWDTGiblXBr4LOap0ZjojM2ommERRU/i/WpFykdE=";
  };

  postPatch = ''
    substituteInPlace src/widgets/activities/terminal.py \
      --replace-fail "['bash', '-c', ';\n'.join(self.prepare_script())]," "['${bash}/bin/bash', '-c', ';\n'.join(self.prepare_script())],"
  '';

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    gtksourceview5
    libadwaita
    libportal
    libspelling
    pipewire # pipewiresrc
    vte-gtk4
    webkitgtk_6_0
  ];

  dependencies =
    with pythonPackages;
    [
      gst-python
      html2text
      markitdown
      matplotlib
      odfpy
      openai
      opencv4
      pandas
      pillow
      pydbus
      pygobject3
      pyicu
      pythonPackages.ollama
      requests
      youtube-transcript-api
      zstandard
    ]
    ++ markitdown.optional-dependencies.docx
    ++ markitdown.optional-dependencies.pdf
    ++ markitdown.optional-dependencies.pptx
    ++ markitdown.optional-dependencies.youtube-transcription
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
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      xdg-utils
      ollama
    ]}"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

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
