{ stdenv, fetchurl, pkgconfig, gtk, gettext, withBuildColors ? true, ncurses ? null}:

assert withBuildColors -> ncurses != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "girara-${version}";
  version = "0.2.5";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "14m8mfbck49ldwi1w2i47bbg5c9daglcmvz9v2g1hnrq8k8g5x2w";
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
