{ stdenv, fetchFromGitHub, yacc, ncurses, libxml2 }:

let
  version = "0.2.1";
in
stdenv.mkDerivation rec {

  name = "sc-im-${version}";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "0v6b8xksvd12vmz198vik2ranyr5mhnp85hl9yxh9svibs7jxsbb";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "SC-IM - Spreadsheet Calculator Improvised - SC fork";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # Cannot test others
  };

}
