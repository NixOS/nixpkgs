{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, perlArchiveZip
, perlCompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, jre }:

stdenv.mkDerivation {
  name = "openoffice.org-2.0.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/OOo_2.0.0_src.tar.gz;
    md5 = "a68933afc2bf432d11b2043ac99ba0aa";
    #url = http://ftp.snt.utwente.nl/pub/software/openoffice/stable/2.2.1/OOo_2.2.1_src_core.tar.bz2;
    #sha256 = "adc54c88892f5ced9887945709856efeb628fe5f7b5b2f2aa7797c5391b9c7d6";
  };
  buildInputs = [ pam python tcsh libxslt perl perlArchiveZip perlCompressZlib zlib 
                  libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
                  libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack getopt file jre ];

}
