{
  lib,
  python3Packages,
  fetchFromGitLab,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gst_all_1,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "showtime";
  version = "46.3";
  pyproject = false;

  src = fetchFromGitLab {
    group = "GNOME";
    owner = "Incubator";
    repo = "showtime";
    rev = "refs/tags/${version}";
    hash = "sha256-0qT62VoodRcrxYNTtZk+KqxzhflxFU/HPtj2u0wRSH0=";
    domain = "gitlab.gnome.org";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    glib # for `glib-compile-schemas`
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-ugly
    libadwaita
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  pythonImportsCheck = [ "showtime" ];

  meta = {
    description = "Watch without distraction";
    homepage = "https://apps.gnome.org/Showtime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "showtime";
  };
}
