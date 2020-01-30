{ stdenv, fetchurl, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "ssw";
  version = "0.3";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/ssw/spread-sheet-widget-${version}.tar.gz";
    sha256 = "1h93yyh2by6yrmkwqg38nd5knids05k5nqzcihc1hdwgzg3c4b8y";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  meta = with stdenv.lib; {
    homepage = "https://www.gnu.org/software/ssw/";
    license = licenses.gpl3;
    description = "GNU Spread Sheet Widget";
    platforms = platforms.linux;
  };
}
