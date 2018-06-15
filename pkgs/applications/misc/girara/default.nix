{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gtk, gettext, libiconv, libintl
}:

stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.3.0";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.xz";
    sha256 = "18j1gv8pi4cpndvnap88pcfacdz3lnw6pxmw7dvzm359y1gzllmp";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];
  buildInputs = [ libintl libiconv ];
  propagatedBuildInputs = [ glib gtk ];

  meta = with stdenv.lib; {
    homepage = https://pwmt.org/projects/girara/;
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK+ based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = licenses.zlib;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.garbas ];
  };
}
