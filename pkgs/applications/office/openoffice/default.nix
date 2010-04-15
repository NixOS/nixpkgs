{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2
}:

let version = "3.1.1"; in
stdenv.mkDerivation rec {
  name = "openoffice.org-${version}";
  builder = ./builder.sh;

  #downloadRoot = "http://download.services.openoffice.org/files/stable";
  downloadRoot = "http://www-openoffice.com/source/";

  src = fetchurl {
      url = "${downloadRoot}/${version}/OOo_${version}_src_core.tar.bz2";
      sha256 = "b44ab94c75b89c9354531ddba9c211374567535e147308a934e8c35d7b26814a";
    };

  patches = [ ./oo.patch ./OOo-3.1.1-HEADERFIX-1.patch ./root-required.patch ];

  src_system = fetchurl {
      url = "${downloadRoot}/${version}/OOo_${version}_src_system.tar.bz2";
      sha256 = "97796333eb2f17e8199026d4ab4334d59bbbffc8d2f9d9100a0c27e823e1305a";
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
    --without-system-jars
    --without-system-hunspell
    --without-system-altlinuxhyph
    --without-system-lpsolve
    --without-system-graphite
  ";

  LD_LIBRARY_PATH = "${libXext}/lib:${libX11}/lib:${libXtst}/lib:${libXi}/lib:${libjpeg}/lib";

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi
    cups libXinerama openssl gperf GConf ORBit2
  ];

  inherit icu fontconfig libjpeg jdk cups;

  meta = {
    description = "OpenOffice.org is a multiplatform and multilingual office suite";
    homepage = http://www.openoffice.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
