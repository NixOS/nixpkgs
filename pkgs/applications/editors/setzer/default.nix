{ lib
, python3Packages
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

python3Packages.buildPythonApplication rec {
  pname = "setzer";
  version = "66";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-hqwwDR9jCk2XptcqpaReZ73jqpq4JpYD3Rc2OmrEPxg=";
  };

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

  dependencies = with python3Packages; [
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
    runHook preCheck

    meson test --print-errorlogs

    runHook postCheck
  '';

  meta = {
    description = "LaTeX editor written in Python with Gtk";
    mainProgram = "setzer";
    homepage = "https://www.cvfosammmm.org/setzer/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
