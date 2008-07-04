{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, perlArchiveZip
, perlCompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, hsqldb, libXext, libX11, libXtst, libXi, cups
, libXinerama
}:

stdenv.mkDerivation rec {
  name = "openoffice.org-2.3.1";
  builder = ./builder.sh;

  src =
    #if (stdenv.system == "i686-linux") then
      #fetchurl {
        # stable 2.3.0 is failing - got the tip on the mailinglist to have look
        # at http://www.openoffice.org/issues/show_bug.cgi?id=74751
        # now I'm trying snapshot because it should already have this patch
        #url = http://ftp.ussg.iu.edu/openoffice/contrib/rc/2.3.1rc1/OOo_2.3.1rc1_src_core.tar.bz2;
        #name = "OOo_2.3.1_src_core.tar.bz2";
        #sha256 = "";
    #} else 
    fetchurl {
      url = http://openoffice.bouncer.osuosl.org/?product=OpenOffice.org&os=src_bzip&lang=core&version=2.3.1;
      name = "OOo_2.3.1_src_core.tar.bz2";
      md5 = "9555a2d5fae9a25c788cc732921ef57a";
    };

  configureFlags = "
    --with-package-format=native
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

  LD_LIBRARY_PATH = "${libXext}/lib:${libX11}/lib:${libXtst}/lib:${libXi}/lib:${libjpeg}/lib";

  buildInputs = [
    pam python tcsh libxslt perl perlArchiveZip perlCompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi
    cups libXinerama
  ];

  inherit icu fontconfig libjpeg jdk cups;

  patches = [./ooo-libtextcat.patch ];

  meta = {
    description = "OpenOffice.org is a multiplatform and multilingual office suite";
    homepage = http://www.openoffice.org/;
    license = "LGPL";
  };
}
