{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  gettext,
  glib,
  gjs,
  ninja,
  gtk4,
  webkitgtk_6_0,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  glib-networking,
  pkg-config,
  libadwaita,
}:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = "foliate";
    tag = version;
    hash = "sha256-QpWJDwatT4zOAPF+dn+Sm5xivk9SIZOvexj0M/Nyu24=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gettext
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    libadwaita
    webkitgtk_6_0
  ];

  meta = {
    description = "Simple and modern GTK eBook reader";
    homepage = "https://johnfactotum.github.io/foliate";
    changelog = "https://github.com/johnfactotum/foliate/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      onny
      aleksana
    ];
    mainProgram = "foliate";
  };
}
