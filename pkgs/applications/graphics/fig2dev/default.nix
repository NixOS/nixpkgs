{ stdenv, fetchurl, ghostscript, libpng } :

let
  version = "3.2.7a";

in stdenv.mkDerivation {
  name = "fig2dev-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/fig2dev-${version}.tar.xz";
    sha256 = "0a7vkfl38fvkhg3na5gr9c4fskas9wbs84y9djg85nzwbshik8mx";
  };

  buildInputs = [ libpng ];

  GSEXE="${ghostscript}/bin/gs";

  meta = with stdenv.lib; {
    description = "Tool to convert Xfig files to other formats";
    homepage = http://mcj.sourceforge.net/;
    license = licenses.xfig;
    platforms = platforms.linux;
  };
}

