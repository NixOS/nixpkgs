{ stdenv
, python2Packages
, pkgconfig
, librsvg
, gobjectIntrospection
, atk
, gtk3
, gtkspell3
, gnome3
, goocanvas2
}:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  pname = "tryton";
  version = "4.8.4";
  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "6cf3091424853e1270d61f3a9b15ad8e6b36a44c28becf216c324ca8dc1474b0";
  };
  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  propagatedBuildInputs = with python2Packages; [
    chardet
    dateutil
    pygtk
    librsvg
    pygobject3
    goocalendar
    cdecimal
  ];
  buildInputs = [
    atk
    gtk3
    gnome3.defaultIconTheme
    gtkspell3
    goocanvas2
  ];
  makeWrapperArgs = [
    ''--set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"''
    ''--set GI_TYPELIB_PATH "$GI_TYPELIB_PATH"''
    ''--suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"''
  ];
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
