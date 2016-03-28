{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "tweak-${version}";
  version = "3.02";

  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/tweak/${name}.tar.gz";
    sha256 = "06js54pr5hwpwyxj77zs5s40n5aqvaw48dkj7rid2d47pyqijk2v";
  };

  buildInputs = [ ncurses ];
  preBuild = "substituteInPlace Makefile --replace '$(DESTDIR)/usr/local' $out";

  meta = with stdenv.lib; {
    description = "An efficient hex editor";
    homepage = "http://www.chiark.greenend.org.uk/~sgtatham/tweak";
    license = licenses.mit;
    platform = platforms.unix;
  };
}
