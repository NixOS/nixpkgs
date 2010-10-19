{ stdenv, fetchurl, intltool, pkgconfig, compiz, compiz_bcop
, compiz_plugins_main, getopt, libjpeg, cairo, pango, gnome }:

let version = "0.8.6"; in

stdenv.mkDerivation rec {
  name = "compiz-plugins-extra-${version}";

  src = fetchurl {
    url = "http://releases.compiz.org/${version}/${name}.tar.bz2";
    sha256 = "1qbxfi332bbadm0ah48frnrl9dkczl111s5a91a0cqz5v7nbw4g1";
  };

  NIX_CFLAGS_COMPILE = "-I${compiz_plugins_main}/include/compiz";

  buildInputs =
    [ intltool pkgconfig compiz compiz_bcop compiz_plugins_main getopt gnome.GConf ];

  meta = {
    homepage = http://www.compiz.org/;
    description = "Extra plugins for Compiz";
  };
}
