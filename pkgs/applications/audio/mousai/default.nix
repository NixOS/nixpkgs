{ lib
, python3
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gst_all_1
, gtk3
, libhandy
, librsvg
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mousai";
  version = "0.3.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    sha256 = "sha256-sBB2kqlC+2qPgQinhGxY8lq9unxgQoOOhDP5o1pUWMo=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gtk3
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
    gtk3
    libhandy
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
