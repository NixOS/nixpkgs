{ lib
, buildPythonApplication
, fetchFromGitHub
, wrapGAppsHook3
, gobject-introspection
, gtk3
, docutils
, gtksourceview
, gtkspell3
, librsvg
, pygobject3
, webkitgtk_4_0
}:

buildPythonApplication rec {
  pname = "formiko";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ondratu";
    repo = "formiko";
    tag = version;
    sha256 = "sha256-slfpkckCvxHJ/jlBP7QAhzaf9TAcS6biDQBZcBTyTKI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    gtk3
  ];
  propagatedBuildInputs = [
    docutils
    gobject-introspection
    gtk3
    gtksourceview
    gtkspell3
    librsvg
    pygobject3
    webkitgtk_4_0
  ];

  # Needs a display
  doCheck = false;

  meta = with lib; {
    description = "reStructuredText editor and live previewer";
    homepage = "https://github.com/ondratu/formiko";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
