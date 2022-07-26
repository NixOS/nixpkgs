{ lib
, python3
, fetchFromGitHub
, meson
, ninja
, gettext
, appstream
, appstream-glib
, wrapGAppsHook
, desktop-file-utils
, gobject-introspection
, gtksourceview4
, gspell
, poppler_gi
, webkitgtk
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setzer";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "v${version}";
    hash = "sha256-IP56jOiiIK9EW4D5yEdLc49rUzcvegAX3Yyk2ERK/pE=";
  };

  format = "other";

  nativeBuildInputs = [
    meson
    ninja
    gettext
    appstream # for appstreamcli
    appstream-glib
    wrapGAppsHook
    desktop-file-utils
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
    pdfminer-six
    pycairo
    pexpect
  ];

  checkPhase = ''
    meson test --print-errorlogs
  '';

  meta = with lib; {
    description = "LaTeX editor written in Python with Gtk";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
