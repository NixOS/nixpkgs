{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
}:

python3Packages.buildPythonApplication rec {
  pname = "ascii-draw";
  version = "1.3.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "ascii-draw";
    tag = "v${version}";
    hash = "sha256-AwcOFqPWPJoZt3spWdl0AlGZ25aEIhP45EO3pjb14hs=";
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

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pyfiglet
    emoji
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Draw diagrams or anything using only ASCII";
    homepage = "https://github.com/Nokse22/ascii-draw";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ascii-draw";
    maintainers = with lib.maintainers; [ aleksana ];
    # gnulib bindtextdomain is missing on various other unix platforms
    platforms = lib.platforms.linux;
  };
}
