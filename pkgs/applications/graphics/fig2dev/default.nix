{ stdenv, fetchurl, ghostscript, libpng } :

let
  version = "3.2.7b";

in stdenv.mkDerivation {
  pname = "fig2dev";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mcj/fig2dev-${version}.tar.xz";
    sha256 = "1ck8gnqgg13xkxq4hrdy706i4xdgrlckx6bi6wxm1g514121pp27";
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

