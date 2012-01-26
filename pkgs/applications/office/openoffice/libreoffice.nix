{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2
, autoconf, openldap, postgresql, bash
, langs ? [ "en-US" "ca" "ru" "eo" "fr" "nl" "de" "en-GB" ]
}:

throw "The expression for libreoffice is still not ready"

stdenv.mkDerivation rec {
  name = "libreoffice-3.4.5.2";

  srcs_download = import ./libreoffice-srcs.nix { inherit fetchurl; };

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/3.4.5/libreoffice-bootstrap-3.4.5.2.tar.bz2";
    sha256 = "05xz6ykddrm6mrgl9jssr2xpg2ir0x6c1c3n1cph0mvd0hiz58x9";
  };

  preConfigure = ''
    sed -i 's,/usr/bin/env bash,${bash}/bin/bash,' Makefile.in bin/unpack-sources

    # Needed to find genccode
    PATH=$PATH:${icu}/sbin
  '';

  buildPhase = ''
    for a in $srcs_download; do
      FILE=$(basename $a)
      # take out the hash
      cp -v $a src/$(echo $FILE | sed 's/[^-]*-//')
    done

    # Remove an exit 1, ignoring the lack of wget or curl
    sed '/wget nor curl/{n;d}' -i download
    ./download

    # Fix svtools: hardcoded jpeg path
    sed -i -e 's,^JPEG3RDLIB=.*,JPEG3RDLIB=${libjpeg}/lib/libjpeg.so,' solenv/inc/libs.mk
    # Fix sysui: wants to create a tar for root
    sed -i -e 's,--own.*root,,' sysui/desktop/slackware/makefile.mk
    # Fix libtextcat: wants to set rpath to /usr/local/lib
    sed -i -e 's,^CONFIGURE_FLAGS.*,& --prefix='$TMPDIR, libtextcat/makefile.mk
    # Fix hunspell: the checks fail due to /bin/bash missing, and I find this fix easier
    sed -i -e 's,make && make check,make,' hunspell/makefile.mk
    # Fix redland: wants to set rpath to /usr/local/lib
    sed -i -e 's,^CONFIGURE_FLAGS.*,& --prefix='$TMPDIR, redland/redland/makefile.mk \
      redland/raptor/makefile.mk redland/rasqal/makefile.mk

    # This to aovid using /lib:/usr/lib at linking
    sed -i '/gb_LinkTarget_LDFLAGS/{ n; /rpath-link/d;}' solenv/gbuild/platform/unxgcc.mk

    find -name "*.cmd" -exec sed -i s,/lib:/usr/lib,, {} \;

    make
  '';

  configureFlags = [
    # Helpful, while testing the expression
    # "--with-num-cpus=4"

    "--enable-verbose"

    # Without these, configure does not finish
    "--disable-gnome-vfs"
    "--disable-gstreamer"
    "--disable-opengl"
    "--without-junit"
    "--without-system-mythes"

    # Without this, it wants to download
    "--with-cairo"
    "--with-system-libs"
    "--with-system-python"
    "--with-system-boost"
    "--with-system-db"

    # I imagine this helps. Copied from go-oo.
    "--disable-epm"
    "--disable-fontooo"
    "--disable-gnome-vfs"
    "--disable-gnome-vfs"
    "--disable-mathmldtd"
    "--disable-mozilla"
    "--disable-odk"
    "--disable-pasf"
    "--disable-dbus"
    "--disable-kde"
    "--disable-kde4"
    "--disable-mono"
    "--with-package-format=native"
    "--with-jdk-home=${jdk}"
    "--with-ant-home=${ant}"
    "--without-afms"
    "--without-dict"
    "--without-fonts"
    "--without-myspell-dicts"
    "--without-nas"
    "--without-ppds"
    "--without-system-agg"
    "--without-system-beanshell"
    "--without-system-hsqldb"
    "--without-system-xalan"
    "--without-system-xerces"
    "--without-system-xml-apis"
    "--without-system-xt"
    "--without-system-jars"
    "--without-system-hunspell"
    "--without-system-altlinuxhyph"
    "--without-system-lpsolve"
    "--without-system-graphite"
    "--without-system-mozilla"
    "--without-system-libwps"
    "--without-system-libwpg"
    "--without-system-redland"
  ];

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi
    cups libXinerama openssl gperf GConf ORBit2
    ant autoconf openldap postgresql cppunit
  ];

  meta = {
    description = "Libre-office, variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
