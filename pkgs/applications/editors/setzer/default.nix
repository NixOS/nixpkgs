{ lib
, python3
, fetchFromGitHub
, meson
, ninja
, gettext
, appstream
, appstream-glib
, wrapGAppsHook4
, desktop-file-utils
, gobject-introspection
, gtk4
, gtksourceview5
, libadwaita
, libportal
, librsvg
, poppler_gi
, webkitgtk_6_0
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setzer";
  version = "60";

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "v${version}";
    hash = "sha256-SfMqGQKJtPTMSv4B70jOvTAIzNQc0AC16mum4fuNch4=";
  };

  format = "other";

  nativeBuildInputs = [
    meson
    ninja
    gettext
    appstream # for appstreamcli
    appstream-glib
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libportal
    librsvg
    poppler_gi
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bibtexparser
    numpy
    pdfminer-six
    pexpect
    pillow
    pycairo
    pygobject3
    pyxdg
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
