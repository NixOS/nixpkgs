{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pandoc,
  pkg-config,
  python3Packages,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "morphosis";
  version = "48.2";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "morphosis";
    tag = version;
    hash = "sha256-wDEhXIt1iup7QxKsmWUjQZGTEZhOuNjpLqzpqs+TPHo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    glib # For `glib-compile-schemas`
    gobject-introspection
    gtk4 # For `gtk-update-icon-cache`
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
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ pandoc ]}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Convert your documents";
    homepage = "https://gitlab.gnome.org/World/morphosis";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "morphosis";
    platforms = lib.platforms.linux;
  };
}
