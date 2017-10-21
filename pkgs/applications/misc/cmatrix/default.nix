{ stdenv, fetchurl, pkgconfig, ncurses }:

let
  version = "1.2a";
in with stdenv.lib;
stdenv.mkDerivation rec {

  name = "cmatrix-${version}";

  src = fetchurl{
    url = "http://www.asty.org/cmatrix/dist/${name}.tar.gz";
    sha256 = "0k06fw2n8nzp1pcdynhajp5prba03gfgsbj91bknyjr5xb5fd9hz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ];

  meta = {
    description = "Simulates the falling characters theme from The Matrix movie";
    longDescription = ''
      CMatrix simulates the display from "The Matrix" and is based
      on the screensaver from the movie's website.  
    '';
    homepage = http://www.asty.org/cmatrix/;
    platforms = ncurses.meta.platforms;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
