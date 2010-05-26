{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2
, autoconf, openldap, postgresql, bash
, langs ? [ "en-US" "ca" "ru" "eo" "fr" "nl" "de" "en-GB" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
in
stdenv.mkDerivation rec {
  name = "go-oo-3.2.0.10";
  # builder = ./builder.sh;

  downloadRoot = "http://download.services.openoffice.org/files/stable";

  src = fetchurl {
      url = "http://download.go-oo.org/OOO320/ooo-build-3.2.0.10.tar.gz";
      sha256 = "0g6n0m9pibn6cx12zslmknzy1p764nqj8vdf45l5flyls9aj3x21";
    };

  srcs_download = (import ./src.nix) fetchurl;

  # Multi-CPU: --with-num-cpus=4 
  configurePhase = ''
    sed -i -e '1s,/bin/bash,${bash}/bin/bash,' $(find bin -type f)
    sed -i -e '1s,/usr/bin/perl,${perl}/bin/perl,' download.in bin/ooinstall bin/generate-bash-completion
    echo "$distroFlags" > distro-configs/SUSE-11.1.conf.in

    ./configure --with-distro=SUSE-11.1 --with-system-libwpd --without-git --with-system-cairo \
      --with-lang="${langsSpaces}"
  '';

  buildPhase = ''
    for a in $srcs_download; do
      FILE=$(basename $a)
      # take out the hash
      cp -v $a src/$(echo $FILE | sed 's/[^-]*-//')
    done
    sed '/-x $WGET/d' -i download
    ./download
    # Needed to find genccode
    PATH=$PATH:${icu}/sbin

    make build.prepare

    set -x
    pushd build/ooo3*-*/
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
    popd
    set +x
    make
  '';

  installPhase = ''
    bin/ooinstall $out
    ensureDir $out/bin
    for a in $out/program/{sbase,scalc,sdraw,simpress,smath,soffice,swriter,soffice.bin}; do
      ln -s $a $out/bin
    done
  '';

  distroFlags = ''
    --with-vendor=NixPkgs
    --with-package-format=native
    --disable-epm
    --disable-fontooo
    --disable-gnome-vfs
    --disable-gnome-vfs
    --disable-mathmldtd
    --disable-mozilla
    --disable-odk
    --disable-pasf
    --disable-dbus
    --disable-kde
    --disable-kde4
    --disable-mono
    --disable-gstreamer
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
    --without-system-mozilla
    --without-system-libwps
    --without-system-libwpg
  '';

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libwpd libxml2 db4 sablotron curl 
    libXaw fontconfig libsndfile neon bison flex zip unzip gtk libmspack 
    getopt file jdk cairo which icu boost libXext libX11 libXtst libXi
    cups libXinerama openssl gperf GConf ORBit2

    ant autoconf openldap postgresql
  ];

  meta = {
    description = "Go-oo - Novell variant of OpenOffice.org";
    homepage = http://go-oo.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
