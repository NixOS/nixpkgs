{ stdenv, fetchurl, yacc, ncurses, libxml2 }:

let
  version = "0.1.8";
in
stdenv.mkDerivation rec {

  name = "scim-${version}";

  src = fetchurl {
    url = "https://github.com/andmarti1424/scim/archive/v${version}.tar.gz";
    sha256 = "0qjixb1hzbdrypbmzwb2iaw5wp57kn7fmm1zpjp4gzjyanrhazs2";
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
