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
}:

python3Packages.buildPythonApplication rec {
  pname = "alpaca";
  version = "1.0.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    rev = version;
    hash = "sha256-GxnYPnrjaJ47/i+pigw+on2dmbHwQSX+STasvqnAtuQ=";
  };

  patches = [
    # Change the way XDG paths are handled so it makes sense outside of flatpak
    ./fix_xdg_path_flatpak.patch
  ];

  postPatch = ''
    substituteInPlace src/local_instance.py \
      --replace-fail '/app/bin/ollama' 'ollama'
    substituteInPlace src/window.py \
      --replace-fail '/app/share' "$out/share"
  '';

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
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
    pillow
    pypdf
    pytube
    html2text
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ xdg-utils ollama ]}"
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
