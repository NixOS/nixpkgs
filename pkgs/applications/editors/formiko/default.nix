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
, webkitgtk
}:

buildPythonApplication rec {
  pname = "formiko";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "ondratu";
    repo = "formiko";
    rev = version;
    sha256 = "0n7w585gbrpn2xcd5n04hivrjarpr2wj260y2kpxpgh93vn52sdi";
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
    webkitgtk
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
