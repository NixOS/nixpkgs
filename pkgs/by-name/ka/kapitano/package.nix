{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  libadwaita,
  python3Packages,
  clamav,
  appstream-glib,
  desktop-file-utils,
  libxml2,
  gobject-introspection,
  wrapGAppsHook4,
  librsvg,
}:
python3Packages.buildPythonApplication rec {
  pname = "kapitano";
  version = "1.1.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "lonerOrz";
    repo = "Kapitano";
    tag = "v${version}";
    hash = "sha256-f+yTeJXA6enEYqQ9eIZa39vsWV+3Fado+kZjrtVU8nY=";
    fetchLFS = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    desktop-file-utils
    libxml2
    pkg-config
    appstream-glib
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  postPatch = ''
    substituteInPlace src/config/paths_config.py \
      --replace-fail 'USER_DATA_DIR = GLib.get_user_data_dir()' 'USER_DATA_DIR = os.path.join(GLib.get_user_data_dir(), "kapitano"); os.makedirs(USER_DATA_DIR, exist_ok=True)'
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix PATH : "${lib.makeBinPath [ clamav ]}"
    )
  '';

  meta = {
    description = "Modern ClamAV front-end that uses gtk4/libadwaita";
    homepage = "https://codeberg.org/zynequ/Kapitano";
    mainProgram = "kapitano";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
}
