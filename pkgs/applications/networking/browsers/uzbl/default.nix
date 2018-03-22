{ stdenv, fetchurl, pkgconfig, python3, makeWrapper
, webkit, glib-networking, gsettings-desktop-schemas, python2Packages
}:
# This package needs python3 during buildtime,
# but Python 2 + packages during runtime.

stdenv.mkDerivation rec {
  name = "uzbl-v0.9.0";

  meta = with stdenv.lib; {
    description = "Tiny externally controllable webkit browser";
    homepage    = "http://uzbl.org/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ raskin dgonyeo ];
  };

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/uzbl/uzbl/archive/v0.9.0.tar.gz";
    sha256 = "0iskhv653fdm5raiidimh9fzlsw28zjqx7b5n3fl1wgbj6yz074k";
  };

  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
    makeFlags="$makeFlags PYINSTALL_EXTRA=--prefix=$out"
    mkdir -p $out/${python3.sitePackages}/
    export PYTHONPATH=$PYTHONPATH:$out/${python3.sitePackages}
  '';

  preFixup = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules" \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
    done
  '';

  nativeBuildInputs = [ pkgconfig python3 makeWrapper ];

  buildInputs = [ gsettings-desktop-schemas webkit ];
  propagatedBuildInputs = with python2Packages; [ pygtk six ];
}
