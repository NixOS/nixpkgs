{ stdenv, fetchurl, pkgconfig, gtk, gettext, withBuildColors ? true, ncurses ? null}:

assert withBuildColors -> ncurses != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.2.4";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "0pnfdsg435b5vc4x8l9pgm77aj7ram1q0bzrp9g4a3bh1r64xq1f";
  };

  preConfigure = ''
    sed -i 's/ifdef TPUT_AVAILABLE/ifneq ($(TPUT_AVAILABLE), 0)/' colors.mk
  '';

  buildInputs = [ pkgconfig gtk gettext ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ optional withBuildColors "TPUT=${ncurses.dev}/bin/tput"
    ++ optional (!withBuildColors) "TPUT_AVAILABLE=0"
    ;

  meta = {
    homepage = http://pwmt.org/projects/girara/;
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK+ based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.garbas ];
  };
}
