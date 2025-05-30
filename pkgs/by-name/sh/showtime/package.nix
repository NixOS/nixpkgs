{
  lib,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  gobject-introspection,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "showtime";
  version = "48.1";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "GNOME";
    owner = "Incubator";
    repo = "showtime";
    rev = "refs/tags/${version}";
    hash = "sha256-uk3KgiLsYjqBhlKssnkWO6D4ufwJb/o+rQYSA7pa1lU=";
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
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gstreamer
    libadwaita
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  pythonImportsCheck = [ "showtime" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Watch without distraction";
    homepage = "https://apps.gnome.org/Showtime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "showtime";
  };
}
