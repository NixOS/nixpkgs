{ stdenv, fetchFromGitHub, yacc, ncurses, libxml2, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "sc-im-${version}";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "1v1cfmfqs5997bqlirp6p7smc3qrinq8dvsi33sk09r33zkzyar0";
  };

  buildInputs = [ yacc ncurses libxml2 pkgconfig ];

  buildPhase = ''
    cd src

    sed -i "s,prefix=/usr,prefix=$out," Makefile
    sed -i "s,-I/usr/include/libxml2,-I$libxml2," Makefile

    make
    export DESTDIR=$out
  '';

  installPhase = ''
    make install prefix=
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "SC-IM - Spreadsheet Calculator Improvised - SC fork";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # Cannot test others
  };

}
