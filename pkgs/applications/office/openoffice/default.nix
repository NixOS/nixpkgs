{stdenv, fetchurl, pam, python, tcsh, libxslt, perl, perlArchiveZip, perlCompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon, bison, flex, zip, unzip, gtk, libmspack, getopt, file}:

stdenv.mkDerivation {
  name = "openoffice.org-2.0.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/OOo_2.0.0_src.tar.gz;
    md5 = "a68933afc2bf432d11b2043ac99ba0aa";
  };
  buildInputs = [pam python tcsh libxslt perl perlArchiveZip perlCompressZlib zlib libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack getopt file];
}
