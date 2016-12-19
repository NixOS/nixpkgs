{ stdenv, fetchurl, pkgconfig, gtk, gettext, withBuildColors ? true, ncurses ? null}:

assert withBuildColors -> ncurses != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.2.6";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "03wsxj27hvcbs3x96nah7j3paclifwlfag8kdph4kldl48srp9pb";
  };

  preConfigure = ''
    sed -i 's/ifdef TPUT_AVAILABLE/ifneq ($(TPUT_AVAILABLE), 0)/' colors.mk
  '';

  buildInputs = [ pkgconfig gtk gettext ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ optional withBuildColors "TPUT=${ncurses.out}/bin/tput"
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
