{ stdenv, fetchurl, pam, python, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfigUpstream, freetype, libwpd
, libxml2, db4, sablotron, curl, libXaw, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, libXext, libX11, libXtst, libXi, cups
, libXinerama, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, gstreamer, gst_plugins_base, mesa
, autoconf, automake, openldap, bash, hunspell, librdf_redland, nss, nspr
, libwpg, dbus_glib, qt4, kde4, clucene_core_2, libcdr, lcms2, vigra
, libiodbc, mdds, saneBackends, mythes, libexttextcat, libvisio
, fontsConf
, langs ? [ "en-US" "en-GB" "ca" "ru" "eo" "fr" "nl" "de" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
  major = "3";
  minor = "6";
  patch = "1";
  tweak = "2";
  subdir = "${major}.${minor}.${patch}";
  version = "${subdir}.${tweak}";
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
      sha256 = "0id4ad8h3fl4s2ax6r4w4af74xvagkv0qwy50f483lqq3a3pl7fl";
    };

    help = fetchSrc {
      name = "help";
      sha256 = "0jd3l3rkhmdvrvgklkmrh9zsg9hlv3vhy6s97fnzhpzr90sjqrs1";
    };

    core = fetchSrc {
      name = "core";
      sha256 = "12zc0zviy1p3gk1v5nm4ks4rzscn68lpnl3kis4q693zhsk8jyh3";
    };
  };
in
stdenv.mkDerivation rec {
  name = "libreoffice-${version}";

  src = srcs.core;

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
    ln -sv ${srcs.translations} $sourceRoot/src/${srcs.translations.name}
  '';

  patchPhase = ''
    find . -type f -print0 | xargs -0 sed -i \
      -e 's,! */bin/bash,!${bash}/bin/bash,' -e 's,\(!\|SHELL=\) */usr/bin/env bash,\1${bash}/bin/bash,' \
      -e 's,! */usr/bin/perl,!${perl}/bin/perl,' -e 's,! */usr/bin/env perl,!${perl}/bin/perl,' \
      -e 's,! */usr/bin/python,!${python}/bin/python,' -e 's,! */usr/bin/env python,!${python}/bin/python,'
    sed -i 's,ANT_OPTS+="\(.*\)",ANT_OPTS+=\1,' apache-commons/java/*/makefile.mk
  '';

  QT4DIR = qt4;
  KDE4DIR = kde4.kdelibs;

  # I set --with-num-cpus=$NIX_BUILD_CORES, as it's the equivalent of
  # enableParallelBuilding=true in this build system.
  preConfigure = ''
    # Needed to find genccode
    PATH=$PATH:${icu}/sbin

    configureFlagsArray=("--with-lang=${langsSpaces}" "--with-num-cpus=$NIX_BUILD_CORES")
  '';

  makeFlags = "SHELL=${bash}/bin/bash";

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
    mkdir -p $out/bin
    for a in sbase scalc sdraw smath swriter spadmin simpress soffice; do
      ln -s $out/lib/libreoffice/program/$a $out/bin/$a
    done
  '';

  configureFlags = [
    #"--enable-verbose"

    # Without these, configure does not finish
    "--without-junit"

    # Without this, it wants to download
    "--enable-python=system"
    "--enable-dbus"
    "--enable-kde4"
    "--disable-odk"
    "--with-system-cairo"
    "--with-system-libs"
    "--with-boost-libdir=${boost}/lib"
    "--with-system-db"
    "--with-openldap" "--enable-ldap"
    "--without-system-libwps"
    "--without-doxygen"

    # I imagine this helps. Copied from go-oo.
    "--disable-epm"
    "--disable-mathmldtd"
    "--disable-mozilla"
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
    "--without-system-mozilla-headers"
    "--without-system-libcmis"

    "--with-java-target-version=1.6" # The default 1.7 not supported
  ];

  buildInputs =
    [ ant ArchiveZip autoconf automake bison boost cairo clucene_core_2
      CompressZlib cppunit cups curl db4 dbus_glib expat file flex fontconfig
      freetype GConf getopt gnome_vfs gperf gst_plugins_base gstreamer gtk
      hunspell icu jdk kde4.kdelibs lcms2 libcdr libexttextcat libiodbc libjpeg
      libmspack librdf_redland librsvg libsndfile libvisio libwpd libwpg libX11
      libXaw libXext libXi libXinerama libxml2 libxslt libXtst mdds mesa mythes
      neon nspr nss openldap openssl ORBit2 pam perl pkgconfigUpstream poppler
      python sablotron saneBackends tcsh unzip vigra which zip zlib
    ];

  meta = {
    description = "Libre-office, variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
