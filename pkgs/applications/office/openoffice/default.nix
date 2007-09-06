{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, perlArchiveZip
, perlCompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, jre, cairo, which
, icu, boost, jdk, ant, hsqldb, libXext
}:

stdenv.mkDerivation rec {
  name = "openoffice.org-2.2.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/office/openoffice/stable/2.2.1/OOo_2.2.1_src_core.tar.bz2;
    sha256 = "1mn7p68m6z3rlwm2ynvvbzz2idpyds2hjmwlhycfsp1gi644ridd";
  };

  configureFlags = "
    --with-package-format=native
    --disable-cups
    --disable-epm
    --disable-fontooo
    --disable-gnome-vfs
    --disable-gnome-vfs
    --disable-mathmldtd
    --disable-mozilla
    --disable-odk
    --disable-pasf
    --disable-qadevooo
    --with-cairo
    --with-system-libs
    --with-system-python
    --with-system-boost
    --with-jdk-home=${jdk}
    --with-ant-home=${ant}
    --without-afms
    --without-dict
    --without-fonts
    --without-myspell-dicts
    --without-nas
    --without-ppds
    --without-system-agg
    --without-system-beanshell
    --without-system-hsqldb
    --without-system-xalan
    --without-system-xerces
    --without-system-xml-apis
    --without-system-xt
    --without-system-db
    --with-system-hsqldb
    --with-hsqldb-jar=${hsqldb}/lib/hsqldb.jar
  ";

  with_jdk_home = jdk;

  buildInputs = [
    pam python tcsh libxslt perl perlArchiveZip perlCompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext
  ];

  inherit icu fontconfig;

  meta = {
    description = "OpenOffice.org is a multiplatform and multilingual office suite";
    homepage = http://www.openoffice.org/;
    license = "LGPL";
  };
}
