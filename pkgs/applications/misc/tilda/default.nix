{ stdenv, fetchurl, pkgconfig
, autoreconfHook, gettext, expat
, confuse, vte, gtk
, makeWrapper
}:

stdenv.mkDerivation rec {

  name = "tilda-${version}";
  version = "1.1.12";

  src = fetchurl {
    url = "https://github.com/lanoxx/tilda/archive/${name}.tar.gz";
    sha256 = "10kjlcdaylkisb8i0cw4wfssg52mrz2lxr5zmw3q4fpnhh2xlaix";
  };

  buildInputs = [ pkgconfig autoreconfHook gettext confuse vte gtk makeWrapper ];

  LD_LIBRARY_PATH = "${expat}/lib"; # ugly hack for xgettext to work during build

  postInstall = ''
    wrapProgram "$out/bin/tilda" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "A Gtk based drop down terminal for Linux and Unix";
    homepage = https://github.com/lanoxx/tilda/;
    license = licenses.gpl3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

