{ stdenv, fetchurl, pkgconfig, python, makeWrapper, pygtk
, webkit, glib_networking, gsettings_desktop_schemas
}:

stdenv.mkDerivation rec {
  name = "uzbl-20120514";

  meta = with stdenv.lib; {
    description = "Tiny externally controllable webkit browser";
    homepage    = "http://uzbl.org/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ raskin ];
  };

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/uzbl/uzbl/archive/2012.05.14.tar.gz";
    sha256 = "1flpf0rg0c3n9bjifr37zxljn9yxslg8vkll7ghkm341x76cbkwn";
  };

  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
    makeFlags="$makeFlags PYINSTALL_EXTRA=--prefix=$out"
  '';

  preFixup = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
    done
  '';

  nativeBuildInputs = [ pkgconfig python makeWrapper ];

  buildInputs = [ gsettings_desktop_schemas webkit pygtk ];
}
