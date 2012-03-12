{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, gstreamer, gstPluginsBase, mesa
, autoconf, automake, openldap, postgresql, bash
, langs ? [ "en-US" "ca" "ru" "eo" "fr" "nl" "de" "en-GB" ]
, force ? false
}:

# **  Checking with hydra if it builds totally **
#if !force then
#  throw ''The expression for libreoffice is still not ready.
#  Set config.libreoffice.force = true; if you want to try it anyway.''
#else
stdenv.mkDerivation rec {
  name = "libreoffice-3.5.0.3";

  srcs_download = import ./libreoffice-srcs.nix { inherit fetchurl; };

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/3.5.0/libreoffice-core-3.5.0.3.tar.xz";
    sha256 = "04hvlj6wzbj3zjpfjq975mgdmf902ywyf94nxcv067asg83qfcvr";
  };

  configureScript = "./autogen.sh";

  preConfigure = ''
    sed -i 's,/usr/bin/env bash,${bash}/bin/bash,' bin/unpack-sources \
      solenv/bin/install-gdb-printers solenv/bin/striplanguagetags.sh

    sed -i 's,/usr/bin/env perl,${perl}/bin/perl,' solenv/bin/concat-deps.pl

    # Needed to find genccode
    PATH=$PATH:${icu}/sbin
  '';

  buildPhase = ''
    mkdir src
    for a in $srcs_download; do
      FILE=$(basename $a)
      # take out the hash
      cp -v $a src/$(echo $FILE | sed 's/[^-]*-//')
    done

    # Remove an exit 1, ignoring the lack of wget or curl
    sed '/wget nor curl/{n;d}' -i download
    ./download

    # Fix sysui: wants to create a tar for root
    sed -i -e 's,--own.*root,,' sysui/desktop/slackware/makefile.mk
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
    "--with-num-cpus=4"

    "--enable-verbose"

    # Without these, configure does not finish
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
    "--without-system-libvisio"
    "--without-system-libcmis"
    "--without-system-nspr"
    "--without-system-nss"
    "--without-system-sampleicc"
    "--without-system-libexttextcat"
  ];

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi mesa
    cups libXinerama openssl gperf GConf ORBit2 gnome_vfs gstreamer gstPluginsBase
    ant autoconf openldap postgresql cppunit poppler librsvg automake
  ];

  meta = {
    description = "Libre-office, variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
