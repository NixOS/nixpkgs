{ lib
, python3
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gst_all_1
, gtk4
, libadwaita
, librsvg
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mousai";
  version = "0.5.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    sha256 = "19i08d8m405jklfwr5yljfr45sic7g2zjbff30r0zfg1sbzcxl76";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk4
    libadwaita
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    requests
  ];

  meta = with lib; {
    description = "Identify any songs in seconds";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
