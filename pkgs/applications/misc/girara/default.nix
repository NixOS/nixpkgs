{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gtk, gettext, libiconv, libintl
}:

stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "https://pwmt.org/projects/girara/download/${name}.tar.xz";
    sha256 = "1kc6n1mxjxa7wvwnqy94qfg8l9jvx9qrvrr2kc7m4g0z20x3a00p";
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
