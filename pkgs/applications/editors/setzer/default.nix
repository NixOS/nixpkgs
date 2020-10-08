{ lib
, python3
, fetchFromGitHub
, meson
, ninja
, gettext
, appstream
, appstream-glib
, wrapGAppsHook
, gobject-introspection
, gtksourceview4
, gspell
, poppler_gi
, webkitgtk
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setzer";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "v${version}";
    sha256 = "1c7jrq20m53y2k8lmh37zldgc3bndldxipx4xq0lz3qq2fv1gg07";
  };

  format = "other";

  nativeBuildInputs = [
    meson
    ninja
    gettext
    appstream # for appstreamcli
    appstream-glib
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtksourceview4
    gspell
    poppler_gi
    webkitgtk
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pyxdg
  ];

  meta = with lib; {
    description = "LaTeX editor written in Python with Gtk";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
