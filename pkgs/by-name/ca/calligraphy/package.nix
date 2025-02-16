{
  lib,
  python3Packages,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
}:

python3Packages.buildPythonApplication rec {
  pname = "calligraphy";
  version = "1.0.1";
  pyproject = false; # Built with meson

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GeopJr";
    repo = "Calligraphy";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vqbrt8zS2PL4Fhc421DY+IkjD4nuGqSNTLlE8IYSmcI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    pyfiglet
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "GTK tool turning text into ASCII banners";
    homepage = "https://calligraphy.geopjr.dev";
    license = with lib.licenses; [
      gpl3Plus
      # and
      cc0
    ];
    mainProgram = "calligraphy";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
