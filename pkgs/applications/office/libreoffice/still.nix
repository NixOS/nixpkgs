{ stdenv, fetchurl, pam, python3, libxslt, perl, ArchiveZip
, CompressZlib, zlib, libjpeg, expat, pkgconfigUpstream, freetype, libwpd
, libxml2, db, sablotron, curl, fontconfig, libsndfile, neon
, bison, flex, zip, unzip, gtk3, gtk2, libmspack, getopt, file, cairo, which
, icu, boost, jdk, ant, cups, xorg, libcmis
, openssl, gperf, cppunit, GConf, ORBit2, poppler
, librsvg, gnome_vfs, mesa, bsh, CoinMP, libwps, libabw
, autoconf, automake, openldap, bash, hunspell, librdf_redland, nss, nspr
, libwpg, dbus_glib, glibc, qt4, kdelibs4, clucene_core, libcdr, lcms, vigra
, unixODBC, mdds, sane-backends, mythes, libexttextcat, libvisio
, fontsConf, pkgconfig, libzip, bluez5, libtool, maven
, libatomic_ops, graphite2, harfbuzz, libodfgen
, librevenge, libe-book, libmwaw, glm, glew, gst_all_1
, gdb, commonsLogging, librdf_rasqal, makeWrapper, gsettings_desktop_schemas
, defaultIconTheme, glib, ncurses
, langs ? [ "en-US" "en-GB" "ca" "ru" "eo" "fr" "nl" "de" "sl" "pl" "hu" ]
, withHelp ? true
, kdeIntegration ? false
}:

let
  primary-src = import ./still-primary-src.nix { inherit fetchurl; };
in

with { inherit (primary-src) major minor subdir version; };

let
  lib = stdenv.lib;
  langsSpaces = lib.concatStringsSep " " langs;

  fetchSrc = {name, sha256}: fetchurl {
    url = "http://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${name}-${version}.tar.xz";
    inherit sha256;
  };

  srcs = {
    third_party = [ (let md5 = "185d60944ea767075d27247c3162b3bc"; in fetchurl rec {
        url = "http://dev-www.libreoffice.org/extern/${md5}-${name}";
        sha256 = "1infwvv1p6i21scywrldsxs22f62x85mns4iq8h6vr6vlx3fdzga";
        name = "unowinreg.dll";
      }) ] ++ (map (x : ((fetchurl {inherit (x) url sha256 name;}) // {inherit (x) md5name md5;})) (import ./libreoffice-srcs-still.nix));

    translations = fetchSrc {
      name = "translations";
      sha256 = "0w77mkxmhxx4qjwdwb8bipcdb4pkvkg202mxbbjrv0aj09k6dhvk";
    };

    # TODO: dictionaries

    help = fetchSrc {
      name = "help";
      sha256 = "12xqzp005dhbh618g3zb30vj7rdmccdqj6ix10jlk0clk66n9kf0";
    };

  };
in stdenv.mkDerivation rec {
  name = "libreoffice-${version}";

  inherit (primary-src) src;

  # Openoffice will open libcups dynamically, so we link it directly
  # to make its dlopen work.
  # It also seems not to mention libdl explicitly in some places.
  NIX_LDFLAGS = "-lcups -ldl";

  # For some reason librdf_redland sometimes refers to rasqal.h instead 
  # of rasqal/rasqal.h
  NIX_CFLAGS_COMPILE="-I${librdf_rasqal}/include/rasqal";

  # If we call 'configure', 'make' will then call configure again without parameters.
  # It's their system.
  configureScript = "./autogen.sh";
  dontUseCmakeConfigure = true;

  postUnpack = ''
    mkdir -v $sourceRoot/src
  '' + (stdenv.lib.concatMapStrings (f: "ln -sfv ${f} $sourceRoot/src/${f.md5 or f.outputHash}-${f.name}\nln -sfv ${f} $sourceRoot/src/${f.name}\n") srcs.third_party)
  + ''
    ln -sv ${srcs.help} $sourceRoot/src/${srcs.help.name}
    ln -svf ${srcs.translations} $sourceRoot/src/${srcs.translations.name}
  '';

  QT4DIR = qt4;

  # Fix boost 1.59 compat
  # Try removing in the next version
  CPPFLAGS = "-DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED";

  preConfigure = ''
    configureFlagsArray=(
      "--with-parallelism=$NIX_BUILD_CORES"
      "--with-lang=${langsSpaces}"
    );

    chmod a+x ./bin/unpack-sources
    patchShebangs .
    # It is used only as an indicator of the proper current directory
    touch solenv/inc/target.mk

    # BLFS patch for Glibc 2.23 renaming isnan
    sed -ire "s@isnan@std::&@g" xmloff/source/draw/ximp3dscene.cxx
  '';

  # fetch_Download_item tries to interpret the name as a variable name
  # Let it do so…
  postConfigure = ''
    sed -e '1ilibreoffice-translations-${version}.tar.xz=libreoffice-translations-${version}.tar.xz' -i Makefile
    sed -e '1ilibreoffice-help-${version}.tar.xz=libreoffice-help-${version}.tar.xz' -i Makefile

    # unit test sd_tiledrendering seems to be fragile
    # http://nabble.documentfoundation.org/libreoffice-5-0-failure-in-CUT-libreofficekit-tiledrendering-td4150319.html
    echo > ./sd/CppunitTest_sd_tiledrendering.mk
    sed -e /CppunitTest_sd_tiledrendering/d -i sd/Module_sd.mk
    # one more fragile test?
    sed -e '/CPPUNIT_TEST(testTdf96536);/d' -i sw/qa/extras/uiwriter/uiwriter.cxx
    # rendering-dependent test
    sed -e '/CPPUNIT_ASSERT_EQUAL(11148L, pOleObj->GetLogicRect().getWidth());/d ' -i sc/qa/unit/subsequent_filters-test.cxx
    # tilde expansion in path processing checks the existence of $HOME
    sed -e 's@rtl::OString sSysPath("~/tmp");@& return ; @' -i sal/qa/osl/file/osl_File.cxx
    # rendering-dependent: on my computer the test table actually doesn't fit…
    # interesting fact: test disabled on macOS by upstream
    sed -re '/DECLARE_WW8EXPORT_TEST[(]testTableKeep, "tdf91083.odt"[)]/,+5d' -i ./sw/qa/extras/ww8export/ww8export.cxx
    # Segfault on DB access
    sed -e 's/CppunitTest_dbaccess_empty_stdlib_save//' -i ./dbaccess/Module_dbaccess.mk
    # one more fragile test?
    sed -e '/CPPUNIT_TEST(testTdf77014);/d' -i sw/qa/extras/uiwriter/uiwriter.cxx
    # rendering-dependent tests
    sed -e '/CPPUNIT_TEST(testCustomColumnWidthExportXLSX)/d' -i sc/qa/unit/subsequent_export-test.cxx
    sed -e '/CPPUNIT_TEST(testColumnWidthExportFromODStoXLSX)/d' -i sc/qa/unit/subsequent_export-test.cxx
    sed -e '/CPPUNIT_TEST(testChartImportXLS)/d' -i sc/qa/unit/subsequent_filters-test.cxx
    sed -z -r -e 's/DECLARE_OOXMLEXPORT_TEST[(]testFlipAndRotateCustomShape,[^)]*[)].[{]/& return;/' -i sw/qa/extras/ooxmlexport/ooxmlexport7.cxx
  '';

  makeFlags = "SHELL=${bash}/bin/bash";

  enableParallelBuilding = true;

  buildPhase = ''
    # This is required as some cppunittests require fontconfig configured
    export FONTCONFIG_FILE=${fontsConf}

    # This to avoid using /lib:/usr/lib at linking
    sed -i '/gb_LinkTarget_LDFLAGS/{ n; /rpath-link/d;}' solenv/gbuild/platform/unxgcc.mk

    find -name "*.cmd" -exec sed -i s,/lib:/usr/lib,, {} \;

    make
  '';

  # It installs only things to $out/lib/libreoffice
  postInstall = ''
    mkdir -p $out/bin $out/share/desktop

    mkdir -p "$out/share/gsettings-schemas/collected-for-libreoffice/glib-2.0/schemas/"

    for a in sbase scalc sdraw smath swriter spadmin simpress soffice; do
      ln -s $out/lib/libreoffice/program/$a $out/bin/$a
      wrapProgram "$out/bin/$a" \
         --prefix XDG_DATA_DIRS : \
         "$out/share:$GSETTINGS_SCHEMAS_PATH" \
         ;
    done

    ln -s $out/bin/soffice $out/bin/libreoffice
    ln -s $out/lib/libreoffice/share/xdg $out/share/applications

    for f in $out/share/applications/*.desktop; do
      substituteInPlace "$f" --replace "Exec=libreofficedev${major}.${minor}" "Exec=libreoffice"
      substituteInPlace "$f" --replace "Exec=libreoffice${major}.${minor}" "Exec=libreoffice"
      substituteInPlace "$f" --replace "Exec=libreoffice" "Exec=libreoffice"
    done

    cp -r sysui/desktop/icons  "$out/share"
    sed -re 's@Icon=libreofficedev[0-9.]*-?@Icon=@' -i "$out/share/applications/"*.desktop
  '';

  configureFlags = [
    "${if withHelp then "" else "--without-help"}"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-beanshell-jar=${bsh}"
    "--with-vendor=NixOS"
    "--with-commons-logging-jar=${commonsLogging}/share/java/commons-logging-1.2.jar"
    "--disable-report-builder"
    "--enable-python=system"
    "--enable-dbus"
    (lib.enableFeature kdeIntegration "kde4")
    "--with-package-format=installed"
    "--enable-epm"
    "--with-jdk-home=${jdk.home}"
    "--with-ant-home=${ant}/lib/ant"
    "--with-system-cairo"
    "--with-system-libs"
    "--with-system-headers"
    "--with-system-openssl"
    "--with-system-libabw"
    "--with-system-libcmis"
    "--with-system-libwps"
    "--with-system-openldap"
    "--with-system-coinmp"

    # Without these, configure does not finish
    "--without-junit"

    # I imagine this helps. Copied from go-oo.
    # Modified on every upgrade, though
    "--disable-odk"
    "--disable-postgresql-sdbc"
    "--disable-firebird-sdbc"
    "--without-fonts"
    "--without-myspell-dicts"
    "--without-doxygen"

    # TODO: package these as system libraries
    "--with-system-beanshell"
    "--without-system-hsqldb"
    "--without-system-altlinuxhyph"
    "--without-system-lpsolve"
    "--without-system-libetonyek"
    "--without-system-libfreehand"
    "--without-system-liblangtag"
    "--without-system-libmspub"
    "--without-system-libpagemaker"
    "--without-system-libgltf"
    # https://github.com/NixOS/nixpkgs/commit/5c5362427a3fa9aefccfca9e531492a8735d4e6f
    "--without-system-orcus"
  ];

  checkPhase = ''
    make unitcheck
    make slowcheck
  '';

  buildInputs = with xorg;
    [ ant ArchiveZip autoconf automake bison boost cairo clucene_core
      CompressZlib cppunit cups curl db dbus_glib expat file flex fontconfig
      freetype GConf getopt gnome_vfs gperf gtk3 gtk2
      hunspell icu jdk lcms libcdr libexttextcat unixODBC libjpeg
      libmspack librdf_redland librsvg libsndfile libvisio libwpd libwpg libX11
      libXaw libXext libXi libXinerama libxml2 libxslt libXtst
      libXdmcp libpthreadstubs mesa mythes gst_all_1.gstreamer
      gst_all_1.gst-plugins-base gsettings_desktop_schemas glib
      neon nspr nss openldap openssl ORBit2 pam perl pkgconfig poppler
      python3 sablotron sane-backends unzip vigra which zip zlib
      mdds bluez5 glibc libcmis libwps libabw
      libxshmfence libatomic_ops graphite2 harfbuzz
      librevenge libe-book libmwaw glm glew ncurses
      libodfgen CoinMP librdf_rasqal defaultIconTheme makeWrapper
    ]
    ++ lib.optional kdeIntegration kdelibs4;

  passthru = {
    inherit srcs;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Comprehensive, professional-quality productivity suite (Still/stable release)";
    homepage = http://libreoffice.org/;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ viric raskin ];
    platforms = platforms.linux;
  };
}
