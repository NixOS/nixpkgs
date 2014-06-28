# when updating version, wait for the build to fail
# run make without sourcing the environment and let libreoffice
# download all extra files
# then list extra files separated by newline and pipe them to
# generate-libreoffice-srcs.sh and copy output to libreoffice-srcs.nix

{ stdenv, fetchurl, pam, python3, tcsh, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfigUpstream, freetype, libwpd
, libxml2, db, sablotron, curl, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, cups, xorg
, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, gstreamer, gst_plugins_base, mesa
, autoconf, automake, openldap, bash, hunspell, librdf_redland, nss, nspr
, libwpg, dbus_glib, glibc, qt4, kde4, clucene_core, libcdr, lcms, vigra
, unixODBC, mdds, saneBackends, mythes, libexttextcat, libvisio
, fontsConf, pkgconfig, libzip, bluez5, libtool, maven, libe-book_00
, libmwaw_02, libatomic_ops, graphite2, harfbuzz
, langs ? [ "en-US" "en-GB" "ca" "ru" "eo" "fr" "nl" "de" "sl" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
  major = "4";
  minor = "2";
  patch = "5";
  tweak = "2";
  subdir = "${major}.${minor}.${patch}";
  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

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

  fetchThirdParty = {name, md5, brief}: fetchurl {
    inherit name md5;
    url = if brief then
            "http://dev-www.libreoffice.org/src/${name}"
          else
            "http://dev-www.libreoffice.org/src/${md5}-${name}";
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
      sha256 = "0nv47r043w151687ks06w786h8azi8gylxma9c7qyjbdj6cdb2ly";
    };

    # TODO: dictionaries

    help = fetchSrc {
      name = "help";
      sha256 = "1kbkdngq39gfq2804v6vnllax4gqs25zlfk6y561iiipld1ncc5v";
    };

  };
in
stdenv.mkDerivation rec {
  name = "libreoffice-${version}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "4bf7898d7d0ba918a8f6668eff0904a549e5a2de837854716e6d996f121817d5";
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
  '' + (stdenv.lib.concatMapStrings (f: "ln -sv ${f} $sourceRoot/src/${f.outputHash}-${f.name}\nln -sv ${f} $sourceRoot/src/${f.name}\n") srcs.third_party)
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

    patch -Np1 -i ${./ooxmlexport.diff};
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

    chmod a+x ./bin/unpack-sources
    # It is used only as an indicator of the proper current directory
    touch solenv/inc/target.mk
  '';

  makeFlags = "SHELL=${bash}/bin/bash";

  enableParallelBuilding = true;

  buildPhase = ''
    # This is required as some cppunittests require fontconfig configured
    export FONTCONFIG_FILE=${fontsConf}

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
    "--with-vendor=NixOS"

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
    # Modified on every upgrade, though
    "--disable-kde"
    "--disable-postgresql-sdbc"
    "--with-package-format=native"
    "--enable-epm"
    "--with-jdk-home=${jdk}/lib/openjdk"
    "--with-ant-home=${ant}/lib/ant"
    "--without-afms"
    "--without-fonts"
    "--without-myspell-dicts"
    "--without-ppds"
    "--without-system-beanshell"
    "--without-system-hsqldb"
    "--without-system-jars"
    "--without-system-altlinuxhyph"
    "--without-system-lpsolve"
    "--without-system-npapi-headers"
    "--without-system-libcmis"

    "--without-system-libetonyek"
    "--without-system-libfreehand"
    "--without-system-libodfgen"
    "--without-system-libabw"
    "--without-system-firebird"
    "--without-system-orcus"
    "--without-system-liblangtag"
    "--without-system-libmspub"
  ];

  checkPhase = ''
    make unitcheck
    make slowcheck
  '';

  buildInputs = with xorg;
    [ ant ArchiveZip autoconf automake bison boost cairo clucene_core
      CompressZlib cppunit cups curl db dbus_glib expat file flex fontconfig
      freetype GConf getopt gnome_vfs gperf gst_plugins_base gstreamer gtk
      hunspell icu jdk kde4.kdelibs lcms libcdr libexttextcat unixODBC libjpeg
      libmspack librdf_redland librsvg libsndfile libvisio libwpd libwpg libX11
      libXaw libXext libXi libXinerama libxml2 libxslt libXtst
      libXdmcp libpthreadstubs mesa mythes
      neon nspr nss openldap openssl ORBit2 pam perl pkgconfigUpstream poppler
      python3 sablotron saneBackends tcsh unzip vigra which zip zlib
      mdds bluez5 glibc libixion
      libxshmfence libe-book_00 libmwaw_02 libatomic_ops graphite2 harfbuzz
    ];

  meta = with stdenv.lib; {
    description = "LibreOffice is a comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = licenses.lgpl3;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
