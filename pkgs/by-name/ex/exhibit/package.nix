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
  itstool,
}:

python3Packages.buildPythonApplication rec {
  pname = "exhibit";
  version = "1.4.2";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "Exhibit";
    tag = "v${version}";
    hash = "sha256-/dug7U8ei+gSdepILLqhnoIBhZ5QZePkREtCUl4p1Hs=";
  };

  postPatch = ''
    substituteInPlace src/logger_lib.py src/window.py \
      --replace-warn 'os.environ["XDG_DATA_HOME"]' 'os.environ.get("XDG_DATA_HOME", os.path.expanduser("~/.local/share"))'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [
    pygobject3
    f3d_egl
    wand
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "3D model viewer for the GNOME desktop powered by f3d";
    homepage = "https://github.com/Nokse22/Exhibit";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "exhibit";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
