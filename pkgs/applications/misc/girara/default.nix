{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gtk, gettext, libiconv, libintl
}:

stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "https://pwmt.org/projects/girara/download/${name}.tar.xz";
    sha256 = "1ddwap5q5cnfdr1q1b110wy7mw1z3khn86k01jl8lqmn02n9nh1w";
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
