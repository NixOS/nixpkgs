# when updating version, wait for the build to fail
# run make without sourcing the environment and let libreoffice
# download all extra files
# then list extra files separated by newline and pipe them to
# generate-libreoffice-srcs.sh and copy output to libreoffice-srcs.nix

{ stdenv, fetchurl, pam, python3, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfigUpstream, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, gstreamer, gst_plugins_base, mesa
, autoconf, automake, openldap, bash, hunspell, librdf_redland, nss, nspr
, libwpg, dbus_glib, glibc, qt4, kde4, clucene_core, libcdr, lcms, vigra
, unixODBC, mdds, saneBackends, mythes, libexttextcat, libvisio
, fontsConf, pkgconfig, libzip, bluez5, libtool, maven
, langs ? [ "en-US" "en-GB" "ca" "ru" "eo" "fr" "nl" "de" "sl" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
  major = "4";
  minor = "0";
  patch = "5";
  tweak = "2";
  subdir = "${major}.${minor}.${patch}";
  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  # configure phase dependency
  liborcus = stdenv.mkDerivation rec {
     version = "0.3.0";
     name = "liborcus-${version}";

     src = fetchurl {
       url = "http://dev-www.libreoffice.org/src/8755aac23317494a9028569374dc87b2-liborcus_0.3.0.tar.bz2";
       sha256 = "0xrw13s390mcpm50apclydl38sw2sdq27csrr1k0d39jna2990ih";
     };

     configureFlags = "--disable-werror";

     buildInputs = [ zlib boost mdds pkgconfig libixion libzip ];
  };

  # configure phase dependency
  liblangtag = stdenv.mkDerivation rec {
     version = "0.4.0";
     name = "liblangtag-${version}";

     src = fetchurl {
       url = "http://dev-www.libreoffice.org/src/54e578c91b1b68e69c72be22adcb2195-${name}.tar.bz2";
       sha256 = "1bjb0fxjmvzxlhr5by9wgisf6w5yvy6wgfzfkjyw6igk39fivdyb";
     };

     buildInputs = [ libtool pkgconfig libxml2 ];
  };
  
  # doesn't work with srcs versioning
  libmspub = stdenv.mkDerivation rec {
     version = "0.0.6";
     name = "libmspub-${version}";

     src = fetchurl {
       url = "http://dev-www.libreoffice.org/src/${name}.tar.gz";
       sha256 = "1zdcvnm0dpac5yqdv34hq9j38cnhyqzyjgb19iyp54ajnwfjhmcq";
     };

     configureFlags = "--disable-werror";
 
     buildInputs = [ zlib libwpd libwpg pkgconfig boost icu ];  
  };

  # doesn't exist in srcs
  libixion = stdenv.mkDerivation rec {
     version = "0.5.0";
     name = "libixion-${version}";

     src = fetchurl {
       url = "http://kohei.us/files/ixion/src/${name}.tar.bz2";
       sha256 = "010k33bfkckx28r4rdk5mkd0mmayy5ng9ja0j0zg0z237gcfgrzb";
     };

     configureFlags = "--with-boost=${boost}";

     buildInputs = [ boost mdds pkgconfig ];  
  };

  fetchThirdParty = {name, md5}: fetchurl {
    inherit name md5;
    url = "http://dev-www.libreoffice.org/src/${md5}-${name}";
  };

  fetchSrc = {name, sha256}: fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  srcs = {
    third_party = [ (fetchurl rec {
        url = "http://dev-www.libreoffice.org/extern/${md5}-${name}";
        md5 = "185d60944ea767075d27247c3162b3bc";
        name = "unowinreg.dll";
      }) ] ++ (map fetchThirdParty (import ./libreoffice-srcs.nix));

    translations = fetchSrc {
      name = "translations";
      sha256 = "0x96wlwr5m7w4k3ygydzak3ycq35hjq60vfi6nfxczlr8pfjyjxv";
    };

    # TODO: dictionaries

    help = fetchSrc {
      name = "help";
      sha256 = "0nab5jcgrrgn0v1yrm18nl9avp4vifbas48l1absz3jmzf9wka7b";
    };

  };
in
stdenv.mkDerivation rec {
  name = "libreoffice-${version}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "195g1iab7j2x7sl326xbq7vya412ns57xrwpv9hqdrb7iiz2n8la";
  };

  # Openoffice will open libcups dynamically, so we link it directly
  # to make its dlopen work.
  NIX_LDFLAGS = "-lcups";

  # If we call 'configure', 'make' will then call configure again without parameters.
  # It's their system.
  configureScript = "./autogen.sh";
  dontUseCmakeConfigure = true;

  postUnpack = ''
    mkdir -v $sourceRoot/src
  '' + (stdenv.lib.concatMapStrings (f: "ln -sv ${f} $sourceRoot/src/${f.outputHash}-${f.name}\n") srcs.third_party)
  + ''
    ln -sv ${srcs.help} $sourceRoot/src/${srcs.help.name}
    tar xf $sourceRoot/src/${srcs.help.name} -C $sourceRoot/../
    ln -sv ${srcs.translations} $sourceRoot/src/${srcs.translations.name}
    tar xf $sourceRoot/src/${srcs.translations.name} -C $sourceRoot/../
  '';

  patchPhase = ''
    find . -type f -print0 | xargs -0 sed -i \
      -e 's,! */bin/bash,!${bash}/bin/bash,' -e 's,\(!\|SHELL=\) */usr/bin/env bash,\1${bash}/bin/bash,' \
      -e 's,! */usr/bin/perl,!${perl}/bin/perl,' -e 's,! */usr/bin/env perl,!${perl}/bin/perl,' \
      -e 's,! */usr/bin/python,!${python3}/bin/${python3.executable},' -e 's,! */usr/bin/env python,!${python3}/bin/${python3.executable},'
    #sed -i 's,ANT_OPTS+="\(.*\)",ANT_OPTS+=\1,' apache-commons/java/*/makefile.mk
  '';

  QT4DIR = qt4;
  KDE4DIR = kde4.kdelibs;

  preConfigure = ''
    # Needed to find genccode
    PATH=$PATH:${icu}/sbin

    configureFlagsArray=(
      "--with-parallelism=$NIX_BUILD_CORES"
      "--with-lang=${langsSpaces}"
    );
  '';

  makeFlags = "SHELL=${bash}/bin/bash";

  enableParallelBuilding = true;

  buildPhase = ''
    # This is required as some cppunittests require fontconfig configured
    export FONTCONFIG_FILE=${fontsConf}

    # Fix sysui: wants to create a tar for root
    sed -i -e 's,--own.*root,,' sysui/desktop/slackware/makefile.mk

    # This to aovid using /lib:/usr/lib at linking
    sed -i '/gb_LinkTarget_LDFLAGS/{ n; /rpath-link/d;}' solenv/gbuild/platform/unxgcc.mk

    find -name "*.cmd" -exec sed -i s,/lib:/usr/lib,, {} \;

    make
  '';

  # It installs only things to $out/lib/libreoffice
  postInstall = ''
    mkdir -p $out/bin $out/share
    for a in sbase scalc sdraw smath swriter spadmin simpress soffice; do
      ln -s $out/lib/libreoffice/program/$a $out/bin/$a
    done
    ln -s $out/bin/soffice $out/bin/libreoffice

    ln -s $out/lib/libreoffice/share/xdg $out/share/applications
    for f in $out/share/applications/*.desktop; do
      substituteInPlace "$f" --replace "Exec=libreoffice4.0" "Exec=$out/bin/soffice"
      substituteInPlace "$f" --replace "Exec=libreoffice" "Exec=$out/bin/soffice"
    done
  '';

  configureFlags = [
    "--with-vender=NixOS"

    # Without these, configure does not finish
    "--without-junit"

    # Without this, it wants to download
    "--enable-python=system"
    "--enable-dbus"
    "--enable-kde4"
    "--disable-odk"
    "--with-system-cairo"
    "--with-system-libs"
    "--with-system-headers"
    "--with-system-openssl"
    "--with-system-openldap"
    "--with-boost-libdir=${boost}/lib"
    "--without-system-libwps"  # TODO
    "--without-doxygen"

    # I imagine this helps. Copied from go-oo.
    "--disable-epm"
    "--disable-mathmldtd"
    "--disable-kde"
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
    "--without-system-altlinuxhyph"
    "--without-system-lpsolve"
    "--without-system-graphite"
    "--without-system-npapi-headers"
    "--without-system-libcmis"
    "--without-system-mozilla"
  ];

  checkPhase = ''
    make unitcheck
    make slowcheck
  '';

  buildInputs =
    [ ant ArchiveZip autoconf automake bison boost cairo clucene_core
      CompressZlib cppunit cups curl db4 dbus_glib expat file flex fontconfig
      freetype GConf getopt gnome_vfs gperf gst_plugins_base gstreamer gtk
      hunspell icu jdk kde4.kdelibs lcms libcdr libexttextcat unixODBC libjpeg
      libmspack librdf_redland librsvg libsndfile libvisio libwpd libwpg libX11
      libXaw libXext libXi libXinerama libxml2 libxslt libXtst mdds mesa mythes
      neon nspr nss openldap openssl ORBit2 pam perl pkgconfigUpstream poppler
      python3 sablotron saneBackends tcsh unzip vigra which zip zlib
      mdds bluez5 glibc libmspub libixion liborcus liblangtag
    ];

  meta = with stdenv.lib; {
    description = "LibreOffice is a comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = licenses.lgpl3;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
