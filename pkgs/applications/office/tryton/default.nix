{ stdenv
, python3Packages
, pkgconfig
, librsvg
, gobject-introspection
, atk
, gtk3
, gtkspell3
, gnome3
, glib
, goocanvas2
, gdk-pixbuf
, pango
, fontconfig
, freetype
, wrapGAppsHook
}:

with stdenv.lib;

python3Packages.buildPythonApplication rec {
  pname = "tryton";
  version = "5.4.2";

  disabled = !python3Packages.isPy3k;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1rca19krvmycdhmi1vb4ixwq0cagmrkhbqry4f19b725nlp8cv0q";
  };

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    dateutil
    pygobject3
    goocalendar
    pycairo
  ];

  buildInputs = [
    atk
    gdk-pixbuf
    glib
    gnome3.adwaita-icon-theme
    goocanvas2
    fontconfig
    freetype
    gtk3
    gtkspell3
    librsvg
    pango
  ];

  strictDeps = false;

  doCheck = false;

  meta = {
    description = "The client of the Tryton application platform";
    longDescription = ''
      The client for Tryton, a three-tier high-level general purpose
      application platform under the license GPL-3 written in Python and using
      PostgreSQL as database engine.

      It is the core base of a complete business solution providing
      modularity, scalability and security.
    '';
    homepage = http://www.tryton.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ johbo udono ];
  };
}
