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
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "8.5.1";
=======
  version = "8.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Sqs6xXnh1I8fhrxVS8p5r7PRqI5rxK0pJWhDQ2qddks=";
  };

=======
    hash = "sha256-X3kITzZBcpN3kYDiT2PTu9UvuWQ/XSq3tVYYMa1btnY=";
  };

  # TODO: remove in the next release
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/Jeffser/Alpaca/pull/1043.patch";
      hash = "sha256-y0NiT0FvyB/fKvi+5E0hSzDs1Ds2ydqRO1My83bnmYY=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    ]
<<<<<<< HEAD
    ++ lib.concatAttrValues optional-dependencies;
=======
    ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
      For a vendor agnostic solution, use: `pkgs.ollama-vulkan`.
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
