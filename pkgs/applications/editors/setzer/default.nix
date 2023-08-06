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
, libhandy
, poppler_gi
, webkitgtk_4_1
, librsvg
, libportal
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setzer";
  version = "56";

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "v${version}";
    hash = "sha256-YCJu8EU+8RD09QNVT/RYF2ZJZ7cp+oawXThqTzg8ENQ=";
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
    gobject-introspection
  ];

  buildInputs = [
    gtksourceview4
    gspell
    libhandy
    poppler_gi
    webkitgtk_4_1
    librsvg
    libportal
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pyxdg
    pdfminer-six
    pycairo
    pexpect
    bibtexparser
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
