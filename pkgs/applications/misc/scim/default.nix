{ stdenv, fetchurl, yacc, ncurses, libxml2 }:

let
  version = "0.1.9";
in
stdenv.mkDerivation rec {

  name = "scim-${version}";

  src = fetchurl {
    url = "https://github.com/andmarti1424/scim/archive/v${version}.tar.gz";
    sha256 = "00rjz344acw0bxv78x1w9jz8snl9lb9qhr9z22phxinidnd3vaaz";
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
    homepage = "https://github.com/andmarti1424/scim";
    description = "SCIM - Spreadsheet Calculator Improvised - SC fork";
    license = {
      fullName = "SCIM License";
      url = "https://github.com/andmarti1424/scim/raw/master/LICENSE";
    };
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux; # Cannot test others
  };

}
