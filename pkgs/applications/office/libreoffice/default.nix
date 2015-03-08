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
, librsvg, gnome_vfs, mesa
, autoconf, automake, openldap, bash, hunspell, librdf_redland, nss, nspr
, libwpg, dbus_glib, glibc, qt4, kde4, clucene_core, libcdr, lcms, vigra
, unixODBC, mdds, saneBackends, mythes, libexttextcat, libvisio
, fontsConf, pkgconfig, libzip, bluez5, libtool, maven
, libatomic_ops, graphite2, harfbuzz, libodfgen
, librevenge, libe-book, libmwaw, glm, glew, gst_all_1
, langs ? [ "en-US" "en-GB" "ca" "ru" "eo" "fr" "nl" "de" "sl" ]
}:

let
  langsSpaces = stdenv.lib.concatStringsSep " " langs;
  major = "4";
  minor = "4";
  patch = "1";
  tweak = "2";
  subdir = "${major}.${minor}.${patch}";
  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  # doesn't exist in srcs
  # 0.8 version is in 0.7.0 tarball
  libixion = stdenv.mkDerivation rec {
     version = "0.7.0";
     name = "libixion-${version}";

     src = fetchurl {
       url = "http://kohei.us/files/ixion/src/${name}.tar.bz2";
       sha256 = "10amvz7fzr1kcy3svfspkdykmspqgpjdmk44cyr406wi7v4lwnf9";
     };

     buildInputs = [ boost mdds pkgconfig ];

     configureFlags = [ "--with-boost=${boost.dev}" ];
  };

  fetchThirdParty = {name, md5, brief, subDir ? ""}: fetchurl {
    inherit name md5;
    url = if brief then
            "http://dev-www.libreoffice.org/src/${subDir}${name}"
          else
            "http://dev-www.libreoffice.org/src/${subDir}${md5}-${name}";
  };

  # Can't find Boost inside LO build
  liborcus = stdenv.mkDerivation rec {
    name = "liborcus-0.7.0";
    src = fetchThirdParty (stdenv.lib.findFirst 
      (x: x.name == "${name}.tar.bz2")
      ("Error: update liborcus version inside LO expression")
      (import ./libreoffice-srcs.nix));

    buildInputs = [ boost mdds pkgconfig zlib libixion ];

    configureFlags = [ "--with-boost=${boost.dev}" ];
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
      sha256 = "0a1p9jd9lgb1mxnj4c55yrlc7q2dsm5s9cyax6cwaya2q5m5xhnk";
    };

    # TODO: dictionaries

    help = fetchSrc {
      name = "help";
      sha256 = "042xp6xz3gb75k332xclwfjyik63zgcw5135967nclim1sl8rgh7";
    };

  };
in
stdenv.mkDerivation rec {
  name = "libreoffice-${version}";

  src = fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "0pa7gf29sgsl6kxs7j1x1zl4ycv682wrj1dg22qc0kb7aijhpm2f";
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
    ln -svf ${srcs.translations} $sourceRoot/src/${srcs.translations.name}
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

    chmod a+x ./bin/unpack-sources
    # It is used only as an indicator of the proper current directory
    touch solenv/inc/target.mk
  '';

  # fetch_Download_item tries to interpret the name as a variable name
  # Let it do so…
  postConfigure = ''
    sed -e '1ilibreoffice-translations-${version}.tar.xz=libreoffice-translations-${version}.tar.xz' -i Makefile
    sed -e '1ilibreoffice-help-${version}.tar.xz=libreoffice-help-${version}.tar.xz' -i Makefile
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
      substituteInPlace "$f" --replace "Exec=libreofficedev${major}.${minor}" "Exec=$out/bin/soffice"
      substituteInPlace "$f" --replace "Exec=libreoffice${major}.${minor}" "Exec=$out/bin/soffice"
      substituteInPlace "$f" --replace "Exec=libreoffice" "Exec=$out/bin/soffice"
    done

    mkdir -p "$out/share/desktop"
    cp -r sysui/desktop/icons  "$out/share/desktop"
    sed -re 's@Icon=libreofficedev[0-9.]*-?@Icon=@' -i "$out/share/applications/"*.desktop
  '';

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.lib}/lib"
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
    "--without-system-libwps"  # TODO
    "--without-doxygen"

    # I imagine this helps. Copied from go-oo.
    # Modified on every upgrade, though
    "--disable-kde"
    "--disable-postgresql-sdbc"
    "--with-package-format=installed"
    "--enable-epm"
    "--with-jdk-home=${jdk.home}"
    "--with-ant-home=${ant}/lib/ant"
    "--without-fonts"
    "--without-myspell-dicts"
    "--without-system-beanshell"
    "--without-system-hsqldb"
    "--without-system-jars"
    "--without-system-altlinuxhyph"
    "--without-system-lpsolve"
    "--without-system-npapi-headers"
    "--without-system-libcmis"

    "--without-system-libetonyek"
    "--without-system-libfreehand"
    "--without-system-libabw"
    "--without-system-firebird"
    "--without-system-liblangtag"
    "--without-system-libmspub"

    "--without-system-libpagemaker"
    "--without-system-coinmp"
    "--without-system-libgltf"
  ];

  checkPhase = ''
    make unitcheck
    make slowcheck
  '';

  buildInputs = with xorg;
    [ ant ArchiveZip autoconf automake bison boost cairo clucene_core
      CompressZlib cppunit cups curl db dbus_glib expat file flex fontconfig
      freetype GConf getopt gnome_vfs gperf gtk
      hunspell icu jdk kde4.kdelibs lcms libcdr libexttextcat unixODBC libjpeg
      libmspack librdf_redland librsvg libsndfile libvisio libwpd libwpg libX11
      libXaw libXext libXi libXinerama libxml2 libxslt libXtst
      libXdmcp libpthreadstubs mesa mythes gst_all_1.gstreamer 
      gst_all_1.gst-plugins-base
      neon nspr nss openldap openssl ORBit2 pam perl pkgconfigUpstream poppler
      python3 sablotron saneBackends tcsh unzip vigra which zip zlib
      mdds bluez5 glibc libixion
      libxshmfence libatomic_ops graphite2 harfbuzz
      librevenge libe-book libmwaw glm glew
      liborcus libodfgen
    ];

  meta = with stdenv.lib; {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = http://libreoffice.org/;
    license = licenses.lgpl3;
    maintainers = [ maintainers.viric maintainers.raskin ];
    platforms = platforms.linux;
  };
}
