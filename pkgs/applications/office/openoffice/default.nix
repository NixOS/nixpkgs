{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2
}:

let version = "3.2.0"; in
stdenv.mkDerivation rec {
  name = "openoffice.org-${version}";
  builder = ./builder.sh;

  downloadRoot = "http://download.services.openoffice.org/files/stable";
  versionDirs = true;

  src = fetchurl {
      url = "${downloadRoot}/${if versionDirs then version + "/" else ""}OOo_${version}_src_core.tar.bz2";
      sha256 = "0jl14rxmvhz86jlhhwqlbr9nfi9p271aknqxada9775qfm6bjjml";
    };

  patches = [ ./oo.patch  ./root-required.patch ];

  src_system = fetchurl {
      url = "${downloadRoot}/${if versionDirs then version + "/" else ""}OOo_${version}_src_system.tar.bz2";
      sha256 = "0nihw4iyh9qc188dkyfjr3zvp6ym6i1spm16j0cyh5rgxcrn6ycp";
    };

  preConfigure = ''
    PATH=$PATH:${icu}/sbin
  '';

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
    --with-system-db
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
