{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, gstreamer, gstPluginsBase, mesa
, autoconf, automake, openldap, bash
, fontsConf
, langs ? [ "ca" "ru" "eo" "fr" "nl" "de" "en-GB" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
in
stdenv.mkDerivation rec {
  name = "libreoffice-3.5.0.3";

  srcs_download = import ./libreoffice-srcs.nix { inherit fetchurl; };

  src_translation = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/3.5.0/libreoffice-translations-3.5.0.3.tar.xz";
    sha256 = "0kk1jb4axjvkmg22yhxx4p9522zix6rr5cs0c5rxzlkm63qw6h8w";
  };

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/3.5.0/libreoffice-core-3.5.0.3.tar.xz";
    sha256 = "04hvlj6wzbj3zjpfjq975mgdmf902ywyf94nxcv067asg83qfcvr";
  };

  configureScript = "./autogen.sh";

  # patches = [ ./disable-uimpress-test.patch ];

  preConfigure = ''
    tar xf $src_translation
    # I think libreoffice expects by default the translations in ./translations
    mv libreoffice-translations-3.5.0.3/translations .

    sed -i 's,/bin/bash,${bash}/bin/bash,' sysui/desktop/share/makefile.mk
    sed -i 's,/usr/bin/env bash,${bash}/bin/bash,' bin/unpack-sources \
      solenv/bin/install-gdb-printers solenv/bin/striplanguagetags.sh

    sed -i 's,/usr/bin/env perl,${perl}/bin/perl,' solenv/bin/concat-deps.pl solenv/bin/ooinstall
    sed -i 's,ANT_OPTS+="\(.*\)",ANT_OPTS+=\1,' apache-commons/java/*/makefile.mk

    # Needed to find genccode
    PATH=$PATH:${icu}/sbin

    export configureFlagsArray=("--with-lang=${langsSpaces}")
  '';

  buildPhase = ''
    export FONTCONFIG_FILE=${fontsConf}
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
    "--disable-postgresql-sdbc"
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
    ant autoconf openldap cppunit poppler librsvg automake
  ];

  meta = {
    description = "Libre-office, variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
