{
  lib,
  python3Packages,
  fetchFromGitLab,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  meson,
  ninja,
  pandoc,
  pkg-config,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:
python3Packages.buildPythonApplication rec {
  pname = "morphosis";
  version = "1.3";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "morphosis";
    rev = "v${version}";
    hash = "sha256-JEZFgON4QkxHDbWSZbDNLpIFctt8mDHdGVVu3Q+WH4U=";
  };

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
    libadwaita
    webkitgtk_6_0
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [
    ''''${gappsWrapperArgs[@]}''
    "--prefix PATH : ${lib.makeBinPath [ pandoc ]}"
  ];

  meta = {
    description = "Convert your documents";
    homepage = "https://gitlab.gnome.org/Monster/morphosis";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "morphosis";
    platforms = lib.platforms.linux;
  };
}
