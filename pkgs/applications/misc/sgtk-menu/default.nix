{ stdenv, fetchFromGitHub, buildPythonApplication, wrapGAppsHook
, gobject-introspection, gtk3, gdk-pixbuf, librsvg, glib
, setuptools, pango, pygobject3, pycairo
}:

buildPythonApplication rec {
  pname = "sgtk-menu";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "sgtk-menu";
    rev = "v${version}";
    sha256 = "1b5bp0ln493c8y63hx0dywjbv4k7z2qgdiy89c99mxdpznb0g3bd";
  };

  # Tests read files in $HOME/.config
  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ gtk3 gobject-introspection librsvg gdk-pixbuf glib ];

  propagatedBuildInputs = [ setuptools pygobject3 pycairo ];

  # Required for librsvg & gdk-pixbuf to work
  strictDeps = false;

  meta = with stdenv.lib; {
    description = "A themeable, searchable, gtk3-based system launcher.";
    homepage = "https://github.com/nwg-piotr/sgtk-menu";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
