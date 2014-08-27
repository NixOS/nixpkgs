{ stdenv, fetchurl, pkgconfig
, autoconf, automake, gettext
, confuse, vte, gtk
}:

stdenv.mkDerivation rec {

  name = "tilda-${version}";
  version = "1.1.12";

  src = fetchurl {
    url = "https://github.com/lanoxx/tilda/archive/${name}.tar.gz";
    sha256 = "10kjlcdaylkisb8i0cw4wfssg52mrz2lxr5zmw3q4fpnhh2xlaix";
  };

  buildInputs = [ pkgconfig autoconf automake gettext confuse vte gtk ];

  preConfigure = ''
    sh autogen.sh
  '';
  
  meta = {
    description = "A Gtk based drop down terminal for Linux and Unix";
    homepage = https://github.com/lanoxx/tilda/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
