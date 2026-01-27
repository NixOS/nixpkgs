{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  gtksourceview4,
  gtkspell3,
  librsvg,
  webkitgtk_4_1,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "formiko";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ondratu";
    repo = "formiko";
    tag = finalAttrs.version;
    hash = "sha256-slfpkckCvxHJ/jlBP7QAhzaf9TAcS6biDQBZcBTyTKI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    gtk3
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    gtksourceview4
    gtkspell3
    librsvg
    webkitgtk_4_1
  ];

  dependencies = [
    python3Packages.pygobject3
    python3Packages.docutils
  ];

  # Needs a display
  doCheck = false;

  meta = {
    description = "reStructuredText editor and live previewer";
    homepage = "https://github.com/ondratu/formiko";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = lib.platforms.linux;
  };
})
