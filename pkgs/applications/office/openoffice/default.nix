{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit
}:

let version = "3.0.1"; in
stdenv.mkDerivation rec {
  name = "openoffice.org-${version}";
  builder = ./builder.sh;

  src = fetchurl {
      url = "http://openoffice.bouncer.osuosl.org/?product=OpenOffice.org&os=src_bzip&lang=core&version=${version}";
      name = "OOo_${version}_src_core.tar.bz2";
      sha256 = "0fgk7n766lzsxn09p8g5ddabw568jw56k9bcdc02nlmk6k3a9qq0";
    };

  patches = [ ./oo.patch ];

  src_system = fetchurl {
      url = "http://openoffice.bouncer.osuosl.org/?product=OpenOffice.org&os=src_bzip&lang=system&version=${version}";
      name = "OOo_${version}_src_system.tar.bz2";
      sha256 = "1zp8lbn5x9wwbv82inqkanaip4l2jyiybjqv1dpx7wbh6nrasgdv";
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
  ";

  LD_LIBRARY_PATH = "${libXext}/lib:${libX11}/lib:${libXtst}/lib:${libXi}/lib:${libjpeg}/lib";

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi
    cups libXinerama openssl gperf
  ];

  inherit icu fontconfig libjpeg jdk cups;

  meta = {
    description = "OpenOffice.org is a multiplatform and multilingual office suite";
    homepage = http://www.openoffice.org/;
    license = "LGPL";
  };
}
