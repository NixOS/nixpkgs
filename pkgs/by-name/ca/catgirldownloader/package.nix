{
  lib,
  fetchFromGitHub,
  python3Packages,
  gtk4,
  libadwaita,
  gobject-introspection,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  gettext,
  desktop-file-utils,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "catgirldownloader";
  version = "0.5";

  __structuredAttrs = true;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "NyarchLinux";
    repo = "CatgirlDownloader";
    tag = finalAttrs.version;
    hash = "sha256-+RyQOgqPZN3AnVdd5mtgppQ/z51VIEeEsiW2RFTnVbk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    gettext
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
  ];

  meta = {
    description = "A GTK4 application that downloads images of catgirl and waifus from multiple sources";
    homepage = "https://github.com/NyarchLinux/CatgirlDownloader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.linux;
  };
})
