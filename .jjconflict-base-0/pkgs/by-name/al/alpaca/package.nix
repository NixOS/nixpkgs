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
  version = "2.9.0";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    rev = "refs/tags/${version}";
    hash = "sha256-ionioPA69haDIyXjqU84nuTNtI32jOnhd6oCTRI6vcA=";
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
    pytube
    html2text
    youtube-transcript-api
    pydbus
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
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
