{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.9.6.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Alpaca";
    rev = version;
    hash = "sha256-EbaEjKqfotJBceaYEyz3LHilK3GnnwEpfMR7Teq96hI=";
  };

  patches = [
    # Change the way XDG paths are handled so it makes sense outside of flatpak
    ./fix_xdg_path_flatpak.patch

    # Let ollama instance stop gracefully so we don't have model instance left behind
    (fetchpatch {
      url = "https://github.com/Jeffser/Alpaca/commit/e81d918675896c1670cf5aa5a55e1b706be5ed51.patch";
      hash = "sha256-gYYFvaoBI/Qn0g2qgS1cB0B4F08swznrSd5KCb51vh0=";
    })
  ];

  postPatch = ''
    substituteInPlace src/local_instance.py \
      --replace-fail '/app/bin/ollama' 'ollama'
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
    '';
    homepage = "https://jeffser.com/alpaca";
    license = lib.licenses.gpl3Plus;
    mainProgram = "alpaca";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
