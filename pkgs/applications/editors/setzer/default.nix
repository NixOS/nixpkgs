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
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "v${version}";
    sha256 = "1llxxjj038nd2p857bjdyyhzskn56826qi259v47vaqlv9hkifil";
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
