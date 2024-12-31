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
}:

python3Packages.buildPythonApplication rec {
  pname = "alpaca";
  version = "3.1.0";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    tag = version;
    hash = "sha256-KPab5TU+Ra1o0FWpD5pkhtP7ylno903GQTqqWlir26s=";
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
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
    pillow
    pypdf
    html2text
    youtube-transcript-api
    pydbus
    odfpy
    pyicu
  ];

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
    platforms = lib.platforms.linux;
  };
}
