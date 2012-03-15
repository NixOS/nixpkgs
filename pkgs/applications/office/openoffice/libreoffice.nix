{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, gstreamer, gst_plugins_base, mesa
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

  src_help = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/3.5.0/libreoffice-help-3.5.0.3.tar.xz";
    sha256 = "0wvlh2r4cy14rs0svr4yb4fidp2g9wbj8vxx2a5swnjf2fdf8qda";
  };

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/3.5.0/libreoffice-core-3.5.0.3.tar.xz";
    sha256 = "04hvlj6wzbj3zjpfjq975mgdmf902ywyf94nxcv067asg83qfcvr";
  };

  # Openoffice will open libcups dynamically, so we link it directly
  # to make its dlopen work.
  NIX_LDFLAGS = "-lcups";

  # If we call 'configure', 'make' will then call configure again without parameters.
  # It's their system.
  configureScript = "./autogen.sh";

  preConfigure = ''
    tar xf $src_translation
    # Libreoffice expects by default the translations in ./translations
    mv libreoffice-translations-3.5.0.3/translations .
    tar xf $src_help
    # Libreoffice expects by default the help in ./helpcontent2
    mv libreoffice-help-3.5.0.3/helpcontent2 .

    sed -i 's,/bin/bash,${bash}/bin/bash,' sysui/desktop/share/makefile.mk solenv/bin/localize
    sed -i 's,/usr/bin/env bash,${bash}/bin/bash,' bin/unpack-sources \
      solenv/bin/install-gdb-printers solenv/bin/striplanguagetags.sh

    sed -i 's,/usr/bin/env perl,${perl}/bin/perl,' solenv/bin/concat-deps.pl solenv/bin/ooinstall
    sed -i 's,ANT_OPTS+="\(.*\)",ANT_OPTS+=\1,' apache-commons/java/*/makefile.mk

    # Needed to find genccode
    PATH=$PATH:${icu}/sbin

    configureFlagsArray=("--with-lang=${langsSpaces}")
  '';

  buildPhase = ''
    # This is required as some cppunittests require fontconfig configured
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

  # It installs only things to $out/lib/libreoffice
  postInstall = ''
    mkdir -p $out/bin
    for a in sbase scalc sdraw smath swriter spadmin simpress soffice; do
      ln -s $out/lib/libreoffice/program/$a $out/bin/$a
    done
  '';

  configureFlags = [
    "--enable-verbose"

    # Without these, configure does not finish
    "--without-junit"
    "--without-system-mythes"

    # Without this, it wants to download
    "--with-system-cairo"
    "--with-system-libs"
    "--enable-python=system"
    "--with-system-boost"
    "--with-system-db"

    # I imagine this helps. Copied from go-oo.
    "--disable-epm"
    "--disable-mathmldtd"
    "--disable-mozilla"
    "--disable-odk"
    "--disable-dbus"
    "--disable-kde"
    "--disable-kde4"
    "--disable-postgresql-sdbc"
    "--with-package-format=native"
    "--with-jdk-home=${jdk}"
    "--with-ant-home=${ant}"
    "--without-afms"
    "--without-fonts"
    "--without-myspell-dicts"
    "--without-ppds"
    "--without-system-beanshell"
    "--without-system-hsqldb"
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
    "--without-system-nss"
    "--without-system-sampleicc"
    "--without-system-libexttextcat"
  ];

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi mesa
    cups libXinerama openssl gperf GConf ORBit2 gnome_vfs gstreamer gst_plugins_base
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
