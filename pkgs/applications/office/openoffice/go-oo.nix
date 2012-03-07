{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfig, freetype
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2
, autoconf, openldap, postgresql, bash
, langs ? [ "en-US" "ca" "ru" "eo" "fr" "nl" "de" "en-GB" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
  tag = "OOO320_m19";
  version = "3.2.1.6";
in
stdenv.mkDerivation rec {
  name = "go-oo-${version}";
  # builder = ./builder.sh;

  src = fetchurl {
      url = "http://download.go-oo.org/OOO320/ooo-build-${version}.tar.gz";
      sha256 = "1l9kpg61wyqjsig5n6a7c7zyygbg09zsmn4q267c12zzpl5qpmxy";
    };

  srcs_download = import ./go-srcs.nix { inherit fetchurl; };

  # Multi-CPU: --with-num-cpus=4 
  # The '--with-tag=XXXX' string I took from their 'configure' script. I write it so it matches the
  # logic in the script for "upstream version for X.X.X". Look for that string in the script.
  # We need '--without-split' when downloading directly usptream openoffice src tarballs.
  configurePhase = ''
    sed -i -e '1s,/bin/bash,${bash}/bin/bash,' $(find bin -type f)
    sed -i -e '1s,/usr/bin/perl,${perl}/bin/perl,' download.in $(find bin -type f)
    sed -i -e '1s,/usr/bin/python,${python}/bin/python,' bin/*.py
    echo "$distroFlags" > distro-configs/SUSE-11.1.conf.in

    ./configure --with-distro=SUSE-11.1 --without-system-libwpd --without-git --with-system-cairo \
      --with-lang="${langsSpaces}" --with-tag=${tag} --without-split
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
    pushd build/${tag}

    patch -p1 < ${./xlib.patch}

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
    mkdir -p $out/bin
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
    --without-system-redland
  '';

  buildInputs = [
    pam python tcsh libxslt perl ArchiveZip CompressZlib zlib 
    libjpeg expat pkgconfig freetype libxml2 db4 sablotron curl 
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
