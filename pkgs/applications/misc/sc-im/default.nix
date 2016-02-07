{ stdenv, fetchurl, yacc, ncurses, libxml2 }:

let
  version = "0.2.1";
in
stdenv.mkDerivation rec {

  name = "sc-im-${version}";

  src = fetchurl {
    url = "https://github.com/andmarti1424/sc-im/archive/v${version}.tar.gz";
    sha256 = "08yks8grj5w434r81dy2knzbdhdnkc23r0d9v848mcl706xnjl6j";
  };

  buildInputs = [ yacc ncurses libxml2 ];

  buildPhase = ''
    cd src

    sed "s,prefix=/usr,prefix=$out," Makefile
    sed "s,-I/usr/include/libxml2,-I$libxml2," Makefile

    make
    export DESTDIR=$out
  '';

  installPhase = ''
    make install prefix=
  '';

  meta = {
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "SC-IM - Spreadsheet Calculator Improvised - SC fork";
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux; # Cannot test others
  };

}
