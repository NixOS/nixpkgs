{
  appstream,
  appstream-glib,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  gobject-introspection,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  libportal,
  librsvg,
  meson,
  ninja,
  poppler_gi,
  python3Packages,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "setzer";
  version = "66";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Setzer";
    tag = "v${version}";
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
