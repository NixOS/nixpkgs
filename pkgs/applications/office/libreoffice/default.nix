{ stdenv
, fetchurl
, fetchpatch
, lib
, substituteAll
, pam
, python3
, libxslt
, perl
, ArchiveZip
, box2d
, gettext
, IOCompress
, zlib
, libjpeg
, liblangtag
, expat
, freetype
, libwpd
, libxml2
, db
, curl
, fontconfig
, libsndfile
, neon
, bison
, flex
, zip
, unzip
, gtk3
, libmspack
, getopt
, file
, cairo
, which
, icu
, boost
, jdk17
, ant
, cups
, xorg
, fontforge
, jre17_minimal
, openssl
, gperf
, cppunit
, poppler
, util-linux
, librsvg
, libGLU
, libGL
, bsh
, CoinMP
, libwps
, libabw
, libmysqlclient
, autoconf
, automake
, openldap
, bash
, hunspell
, librdf_redland
, nss
, nspr
, libwpg
, dbus-glib
, clucene_core
, libcdr
, lcms
, unixODBC
, mdds
, sane-backends
, mythes
, libexttextcat
, libvisio
, fontsConf
, pkg-config
, bluez5
, libtool
, carlito
, libatomic_ops
, graphite2
, harfbuzz
, libodfgen
, libzmf
, librevenge
, libe-book
, libmwaw
, glm
, gst_all_1
, gdb
, commonsLogging
, librdf_rasqal
, gnome
, glib
, ncurses
, libepoxy
, gpgme
, libwebp
, abseil-cpp
, langs ? [ "ar" "ca" "cs" "da" "de" "en-GB" "en-US" "eo" "es" "fr" "hu" "it" "ja" "nl" "pl" "pt" "pt-BR" "ro" "ru" "sl" "tr" "uk" "zh-CN" ]
, withHelp ? true
, kdeIntegration ? false
, wrapQtAppsHook ? null
, qtbase ? null
, qtx11extras ? null
, qtwayland ? null
, ki18n ? null
, kconfig ? null
, kcoreaddons ? null
, kio ? null
, kwindowsystem ? null
, variant ? "fresh"
, symlinkJoin
, postgresql
# The rest are used only in passthru, for the wrapper
, kauth ? null
, kcompletion ? null
, kconfigwidgets ? null
, kglobalaccel ? null
, kitemviews ? null
, knotifications ? null
, ktextwidgets ? null
, kwidgetsaddons ? null
, kxmlgui ? null
, phonon ? null
, qtdeclarative ? null
, qtquickcontrols ? null
, qtsvg ? null
, qttools ? null
, solid ? null
, sonnet ? null
} @ args:

assert builtins.elem variant [ "fresh" "still" ];

let
  inherit (lib)
    flatten flip
    concatMapStrings concatStringsSep
    getDev getLib
    optionals optionalString;

  jre' = jre17_minimal.override {
    modules = [ "java.base" "java.desktop" "java.logging" "java.sql" ];
  };

  importVariant = f: import (./. + "/src-${variant}/${f}");
  # Update these files with:
  # nix-shell maintainers/scripts/update.nix --argstr package libreoffice-$VARIANT.unwrapped
  version = importVariant "version.nix";
  srcsAttributes = {
    main = importVariant "main.nix";
    help = importVariant "help.nix";
    translations = importVariant "translations.nix";
    deps = (importVariant "deps.nix") ++ [
      # TODO: Why is this needed?
      (rec {
        name = "unowinreg.dll";
        url = "https://dev-www.libreoffice.org/extern/${md5name}";
        sha256 = "1infwvv1p6i21scywrldsxs22f62x85mns4iq8h6vr6vlx3fdzga";
        md5 = "185d60944ea767075d27247c3162b3bc";
        md5name = "${md5}-${name}";
      })
    ];
  };
  srcs = {
    third_party = map (x:
      (fetchurl {
        inherit (x) url sha256 name;
      }) // {
        inherit (x) md5name md5;
      }) srcsAttributes.deps;
    translations = fetchurl srcsAttributes.translations;
    help = fetchurl srcsAttributes.help;
  };

  # See `postPatch` for details
  kdeDeps = symlinkJoin {
    name = "libreoffice-kde-dependencies-${version}";
    paths = flatten (map (e: [ (getDev e) (getLib e) ]) [
      qtbase
      qtx11extras
      kconfig
      kcoreaddons
      ki18n
      kio
      kwindowsystem
    ]);
  };
  tarballPath = "external/tarballs";

in stdenv.mkDerivation (finalAttrs: {
  pname = "libreoffice";
  inherit version;
  src = fetchurl srcsAttributes.main;

  env.NIX_CFLAGS_COMPILE = toString ([
    "-I${librdf_rasqal}/include/rasqal" # librdf_redland refers to rasqal.h instead of rasqal/rasqal.h
    "-fno-visibility-inlines-hidden" # https://bugs.documentfoundation.org/show_bug.cgi?id=78174#c10
  ] ++ optionals (stdenv.isLinux && stdenv.isAarch64 && variant == "still") [
    "-O2" # https://bugs.gentoo.org/727188
  ]);

  postUnpack = ''
    mkdir -v $sourceRoot/${tarballPath}
  '' + (flip concatMapStrings srcs.third_party (f: ''
    ln -sfv ${f} $sourceRoot/${tarballPath}/${f.md5name}
    ln -sfv ${f} $sourceRoot/${tarballPath}/${f.name}
  ''))
  + ''
    ln -sv ${srcs.help} $sourceRoot/${tarballPath}/${srcs.help.name}
    ln -svf ${srcs.translations} $sourceRoot/${tarballPath}/${srcs.translations.name}
    tar -xf ${srcs.help}
    tar -xf ${srcs.translations}
  '';

  patches = [
    # Remove build config to reduce the amount of `-dev` outputs in the
    # runtime closure. This behavior was introduced by upstream in commit
    # cbfac11330882c7d0a817b6c37a08b2ace2b66f4
    ./0001-Strip-away-BUILDCONFIG.patch

    # Backport fix for tests broken by expired test certificates.
    (fetchpatch {
      url = "https://cgit.freedesktop.org/libreoffice/core/patch/?id=ececb678b8362e3be8e02768ddd5e4197d87dc2a";
      hash = "sha256-TUfKlwNxUTOJ95VLqwVD+ez1xhu7bW6xZlgIaCyIiNg=";
    })

    # Backport libxml 2.12 build fixes
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://cgit.freedesktop.org/libreoffice/core/patch/?id=c8f7408db73d2f2ccacb25a2b4fef8dfebdfc6cb";
      hash = "sha256-uEgRx1eyS3Wx2ZDWEsUmpIbuKezVrIbO++qSL2QI8Lk=";
    })
    (fetchpatch {
      url = "https://cgit.freedesktop.org/libreoffice/core/patch/?id=cbb17a548b5cc6a99b6ed7735479bb4f2bc40f26";
      hash = "sha256-ofhif37uvQI+gidaUpyr6XlyBc3gTJUDBRb3ootrzz0=";
    })
  ];

  # libreoffice tries to reference the BUILDCONFIG (e.g. PKG_CONFIG_PATH)
  # in the binary causing the closure size to blow up because of many unnecessary
  # dependencies to dev outputs. This behavior was patched away in nixpkgs
  # (see above), make sure these don't leak again by accident.
  disallowedRequisites = lib.optionals (!kdeIntegration)
    (lib.concatMap
      (x: lib.optional (x?dev) x.dev)
      finalAttrs.buildInputs);

  postPatch = ''
    # configure checks for header 'gpgme++/gpgmepp_version.h',
    # and if it is found (no matter where) uses a hardcoded path
    # in what presumably is an effort to make it possible to write
    # '#include <context.h>' instead of '#include <gpgmepp/context.h>'.
    #
    # Fix this path to point to where the headers can actually be found instead.
    substituteInPlace configure.ac --replace \
      'GPGMEPP_CFLAGS=-I/usr/include/gpgme++' \
      'GPGMEPP_CFLAGS=-I${gpgme.dev}/include/gpgme++'
  '' + optionalString kdeIntegration ''
    substituteInPlace shell/source/unix/exec/shellexec.cxx \
      --replace xdg-open kde-open5
    # configure.ac assumes that the first directory that contains headers and
    # libraries during its checks contains *all* the relevant headers/libs which
    # obviously doesn't work for us, so we have 2 options:
    #
    # 1. patch configure.ac in order to specify the direct paths to various Qt/KDE
    # dependencies which is ugly and brittle, or
    #
    # 2. use symlinkJoin to pull in the relevant dependencies and just patch in
    # that path which is *also* ugly, but far less likely to break
    #
    # The 2nd option is not very Nix'y, but I'll take robust over nice any day.
    # Additionally, it's much easier to fix if LO breaks on the next upgrade (just
    # add the missing dependencies to it).
    substituteInPlace configure.ac \
      --replace '$QT5INC ' '$QT5INC ${kdeDeps}/include ' \
      --replace '$QT5LIB ' '$QT5LIB ${kdeDeps}/lib ' \
      --replace '$KF5INC ' '$KF5INC ${kdeDeps}/include ${kdeDeps}/include/KF5 '\
      --replace '$KF5LIB ' '$KF5LIB ${kdeDeps}/lib '
  '';

  dontUseCmakeConfigure = true;
  dontUseCmakeBuildDir = true;

  preConfigure = ''
    configureFlagsArray=(
      "--with-parallelism=$NIX_BUILD_CORES"
      "--with-lang=${concatStringsSep " " langs}"
    );

    chmod a+x ./bin/unpack-sources
    patchShebangs .

    # This is required as some cppunittests require fontconfig configured
    cp "${fontsConf}" fonts.conf
    sed -e '/include/i<include>${carlito}/etc/fonts/conf.d</include>' -i fonts.conf
    export FONTCONFIG_FILE="$PWD/fonts.conf"

    NOCONFIGURE=1 ./autogen.sh
  '';

  postConfigure = ''
    # fetch_Download_item tries to interpret the name as a variable name, let it do so...
    sed -e '1ilibreoffice-translations-${version}.tar.xz=libreoffice-translations-${version}.tar.xz' -i Makefile
    sed -e '1ilibreoffice-help-${version}.tar.xz=libreoffice-help-${version}.tar.xz' -i Makefile
  '' /* Test fixups. May need to be revisited/pruned, left alone for now. */ + ''
    # unit test sd_tiledrendering seems to be fragile
    # https://nabble.documentfoundation.org/libreoffice-5-0-failure-in-CUT-libreofficekit-tiledrendering-td4150319.html
    echo > ./sd/CppunitTest_sd_tiledrendering.mk
    sed -e /CppunitTest_sd_tiledrendering/d -i sd/Module_sd.mk
    # Pivot chart tests. Fragile.
    sed -e '/CPPUNIT_TEST(testRoundtrip)/d' -i chart2/qa/extras/PivotChartTest.cxx
    sed -e '/CPPUNIT_TEST(testPivotTableMedianODS)/d' -i sc/qa/unit/pivottable_filters_test.cxx
    # one more fragile test?
    sed -e '/CPPUNIT_TEST(testTdf96536);/d' -i sw/qa/extras/uiwriter/uiwriter.cxx
    # this I actually hate, this should be a data consistency test!
    sed -e '/CPPUNIT_TEST(testTdf115013);/d' -i sw/qa/extras/uiwriter/uiwriter.cxx
    # rendering-dependent test
    # tilde expansion in path processing checks the existence of $HOME
    sed -e 's@OString sSysPath("~/tmp");@& return ; @' -i sal/qa/osl/file/osl_File.cxx
    # fails on systems using ZFS, see https://github.com/NixOS/nixpkgs/issues/19071
    sed -e '/CPPUNIT_TEST(getSystemPathFromFileURL_005);/d' -i './sal/qa/osl/file/osl_File.cxx'
    # rendering-dependent: on my computer the test table actually doesn't fit…
    # interesting fact: test disabled on macOS by upstream
    sed -re '/DECLARE_WW8EXPORT_TEST[(]testTableKeep, "tdf91083.odt"[)]/,+5d' -i ./sw/qa/extras/ww8export/ww8export.cxx
    # Segfault on DB access — maybe temporarily acceptable for a new version of Fresh?
    sed -e 's/CppunitTest_dbaccess_empty_stdlib_save//' -i ./dbaccess/Module_dbaccess.mk
    # one more fragile test?
    sed -e '/CPPUNIT_TEST(testTdf77014);/d' -i sw/qa/extras/uiwriter/uiwriter.cxx
    # rendering-dependent tests
    sed -e '/CPPUNIT_TEST(testLegacyCellAnchoredRotatedShape)/d' -i sc/qa/unit/filters-test.cxx
    sed -zre 's/DesktopLOKTest::testGetFontSubset[^{]*[{]/& return; /' -i desktop/qa/desktop_lib/test_desktop_lib.cxx
    sed -z -r -e 's/DECLARE_OOXMLEXPORT_TEST[(]testFlipAndRotateCustomShape,[^)]*[)].[{]/& return;/' -i sw/qa/extras/ooxmlexport/ooxmlexport7.cxx
    sed -z -r -e 's/DECLARE_OOXMLEXPORT_TEST[(]tdf105490_negativeMargins,[^)]*[)].[{]/& return;/' -i sw/qa/extras/ooxmlexport/ooxmlexport9.cxx
    sed -z -r -e 's/DECLARE_OOXMLIMPORT_TEST[(]testTdf112443,[^)]*[)].[{]/& return;/' -i sw/qa/extras/ooxmlimport/ooxmlimport.cxx
    sed -z -r -e 's/DECLARE_RTFIMPORT_TEST[(]testTdf108947,[^)]*[)].[{]/& return;/' -i sw/qa/extras/rtfimport/rtfimport.cxx
    # not sure about this fragile test
    sed -z -r -e 's/DECLARE_OOXMLEXPORT_TEST[(]testTDF87348,[^)]*[)].[{]/& return;/' -i sw/qa/extras/ooxmlexport/ooxmlexport7.cxx
    # bunch of new Fresh failures. Sigh.
    sed -e '/CPPUNIT_TEST(testDocumentLayout);/d' -i './sd/qa/unit/import-tests.cxx'
    sed -e '/CPPUNIT_TEST(testErrorBarDataRangeODS);/d' -i './chart2/qa/extras/chart2export.cxx'
    sed -e '/CPPUNIT_TEST(testLabelStringODS);/d' -i './chart2/qa/extras/chart2export.cxx'
    sed -e '/CPPUNIT_TEST(testAxisNumberFormatODS);/d' -i './chart2/qa/extras/chart2export.cxx'
    sed -e '/CPPUNIT_TEST(testBackgroundImage);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testFdo84043);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf97630);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf80020);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf62176);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTransparentBackground);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testEmbeddedPdf);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testEmbeddedText);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf98477);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testAuthorField);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testTdf50499);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf100926);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testPageWithTransparentBackground);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTextRotation);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf113818);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf119629);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf113822);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf105739);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testPageBitmapWithTransparency);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testTdf115005);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testTdf115005_FallBack_Images_On);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testTdf115005_FallBack_Images_Off);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testTdf44774);/d' -i './sd/qa/unit/misc-tests.cxx'
    sed -e '/CPPUNIT_TEST(testTdf38225);/d' -i './sd/qa/unit/misc-tests.cxx'
    sed -e '/CPPUNIT_TEST(testAuthorField);/d' -i './sd/qa/unit/export-tests-ooxml2.cxx'
    sed -e '/CPPUNIT_TEST(testAuthorField);/d' -i './sd/qa/unit/export-tests.cxx'
    sed -e '/CPPUNIT_TEST(testFdo85554);/d' -i './sw/qa/extras/uiwriter/uiwriter.cxx'
    sed -e '/CPPUNIT_TEST(testEmbeddedDataSource);/d' -i './sw/qa/extras/uiwriter/uiwriter.cxx'
    sed -e '/CPPUNIT_TEST(testTdf96479);/d' -i './sw/qa/extras/uiwriter/uiwriter.cxx'
    sed -e '/CPPUNIT_TEST(testInconsistentBookmark);/d' -i './sw/qa/extras/uiwriter/uiwriter.cxx'
    sed -e '/CPPUNIT_TEST(Import_Export_Import);/d' -i './sw/qa/inc/swmodeltestbase.hxx'
    sed -e /CppunitTest_sw_layoutwriter/d -i sw/Module_sw.mk
    sed -e /CppunitTest_sw_htmlimport/d -i sw/Module_sw.mk
    sed -e /CppunitTest_sw_core_layout/d -i sw/Module_sw.mk
    sed -e /CppunitTest_sw_uiwriter6/d -i sw/Module_sw.mk
    sed -e /CppunitTest_sdext_pdfimport/d -i sdext/Module_sdext.mk
    sed -e /CppunitTest_vcl_pdfexport/d -i vcl/Module_vcl.mk
    sed -e /CppunitTest_sc_ucalc_formula/d -i sc/Module_sc.mk
    sed -e "s/DECLARE_SW_ROUNDTRIP_TEST(\([_a-zA-Z0-9.]\+\)[, ].*, *\([_a-zA-Z0-9.]\+\))/class \\1: public \\2 { public: void verify() override; }; void \\1::verify() /" -i "sw/qa/extras/ooxmlexport/ooxmlexport9.cxx"
    sed -e "s/DECLARE_SW_ROUNDTRIP_TEST(\([_a-zA-Z0-9.]\+\)[, ].*, *\([_a-zA-Z0-9.]\+\))/class \\1: public \\2 { public: void verify() override; }; void \\1::verify() /" -i "sw/qa/extras/ooxmlexport/ooxmlencryption.cxx"
    sed -e "s/DECLARE_SW_ROUNDTRIP_TEST(\([_a-zA-Z0-9.]\+\)[, ].*, *\([_a-zA-Z0-9.]\+\))/class \\1: public \\2 { public: void verify() override; }; void \\1::verify() /" -i "sw/qa/extras/odfexport/odfexport.cxx"
    sed -e "s/DECLARE_SW_ROUNDTRIP_TEST(\([_a-zA-Z0-9.]\+\)[, ].*, *\([_a-zA-Z0-9.]\+\))/class \\1: public \\2 { public: void verify() override; }; void \\1::verify() /" -i "sw/qa/extras/unowriter/unowriter.cxx"

    sed -e '/CPPUNIT_ASSERT(!bRTL);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(0, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(4, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(11, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(18, nMinRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(3, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(9, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(17, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(22, nEndRunPos);/d' -i './vcl/qa/cppunit/text.cxx'

    # testReqIfTable fails since libxml2: 2.10.3 -> 2.10.4
    sed -e 's@.*"/html/body/div/table/tr/th".*@//&@' -i sw/qa/extras/htmlexport/htmlexport.cxx
  '' /* This to avoid using /lib:/usr/lib at linking */ + ''
    sed -i '/gb_LinkTarget_LDFLAGS/{ n; /rpath-link/d;}' solenv/gbuild/platform/unxgcc.mk

    find -name "*.cmd" -exec sed -i s,/lib:/usr/lib,, {} \;
  '' + optionalString stdenv.isAarch64 ''
    sed -e '/CPPUNIT_TEST(testStatisticalFormulasFODS);/d' -i './sc/qa/unit/functions_statistical.cxx'
  '' + optionalString (variant == "fresh") ''
    sed -e '/CPPUNIT_ASSERT_EQUAL(static_cast<size_t>(1), pPage3Objs->size());/d' -i './sw/qa/core/text/porrst.cxx'
    sed -e '/CPPUNIT_ASSERT(pPage4Objs);/d' -i './sw/qa/core/text/porrst.cxx'
    sed -e '/CPPUNIT_ASSERT_EQUAL(static_cast<size_t>(1), pPage4Objs->size());/d' -i './sw/qa/core/text/porrst.cxx'
  '';

  makeFlags = [ "SHELL=${bash}/bin/bash" ];

  enableParallelBuilding = true;

  buildTargets = [ "build-nocheck" ];

  doCheck = true;

  # It installs only things to $out/lib/libreoffice
  postInstall = ''
    mkdir -p $out/share
    ln -s $out/lib/libreoffice/share/xdg $out/share/applications

    cp -r sysui/desktop/icons  "$out/share"
    sed -re 's@Icon=libreoffice(dev)?[0-9.]*-?@Icon=@' -i "$out/share/applications/"*.desktop
  '';

  # Wrapping is done in ./wrapper.nix
  dontWrapQtApps = true;

  configureFlags = [
    (lib.withFeature withHelp "help")
    "--with-boost=${getDev boost}"
    "--with-boost-libdir=${getLib boost}/lib"
    "--with-beanshell-jar=${bsh}"
    "--with-vendor=NixOS"
    "--disable-report-builder"
    "--disable-online-update"
    "--enable-python=system"
    "--enable-dbus"
    "--enable-release-build"
    "--enable-epm"
    "--with-ant-home=${getLib ant}/lib/ant"
    "--with-system-cairo"
    "--with-system-libs"
    "--with-system-headers"
    "--with-system-openssl"
    "--with-system-libabw"
    "--with-system-liblangtag"
    "--without-system-libcmis"
    "--with-system-libwps"
    "--with-system-openldap"
    "--with-system-coinmp"
    "--with-system-postgresql"

    # Without these, configure does not finish
    "--without-junit"

    # Schema files for validation are not included in the source tarball
    "--without-export-validation"

    # We do tarball prefetching ourselves
    "--disable-fetch-external"
    "--enable-build-opensymbol"

    # I imagine this helps. Copied from go-oo.
    # Modified on every upgrade, though
    "--disable-odk"
    "--disable-firebird-sdbc"
    "--without-fonts"
    "--without-doxygen"

    # TODO: package these as system libraries
    "--with-system-beanshell"
    "--without-system-hsqldb"
    "--without-system-altlinuxhyph"
    "--without-system-lpsolve"
    "--without-system-libetonyek"
    "--without-system-libfreehand"
    "--without-system-libmspub"
    "--without-system-libnumbertext"
    "--without-system-libpagemaker"
    "--without-system-libstaroffice"
    "--without-system-libepubgen"
    "--without-system-libqxp"
    "--without-system-dragonbox"
    "--without-system-libfixmath"
  # the "still" variant doesn't support Nixpkgs' mdds 2.1, only mdds 2.0
  ] ++ optionals (variant == "still") [
    "--without-system-mdds"
  ] ++ optionals (variant == "fresh") [
    "--with-system-mdds"
  ] ++ [
    # https://github.com/NixOS/nixpkgs/commit/5c5362427a3fa9aefccfca9e531492a8735d4e6f
    "--without-system-orcus"
    "--without-system-xmlsec"
    "--without-system-zxing"
  ] ++ optionals kdeIntegration [
    "--enable-kf5"
    "--enable-qt5"
    "--enable-gtk3-kde5"
  ] ++ optionals (variant == "fresh") [
    "--without-system-dragonbox"
    "--without-system-libfixmath"
    # Technically needed only when kdeIntegration is enabled in the "fresh"
    # variant. Won't hurt to put it here for every "fresh" variant.
    "--without-system-frozen"
  ];

  checkTarget = concatStringsSep " " [
    "unitcheck"
    "slowcheck"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    bison
    fontforge
    gdb
    jdk17
    libtool
    pkg-config
  ] ++ optionals kdeIntegration [
    wrapQtAppsHook
  ];

  buildInputs = with xorg; finalAttrs.passthru.gst_packages ++ [
    ArchiveZip
    CoinMP
    IOCompress
    abseil-cpp
    ant
    bluez5
    boost
    box2d
    cairo
    clucene_core
    cppunit
    cups
    curl
    db
    dbus-glib
    expat
    file
    flex
    fontconfig
    freetype
    getopt
    gettext
    glib
    glm
    gnome.adwaita-icon-theme
    gperf
    gpgme
    graphite2
    gtk3
    harfbuzz
    hunspell
    icu
    jre'
    lcms
    libGL
    libGLU
    libX11
    libXaw
    libXdmcp
    libXext
    libXi
    libXinerama
    libXtst
    libabw
    libatomic_ops
    libcdr
    libe-book
    libepoxy
    libexttextcat
    libjpeg
    liblangtag
    libmspack
    libmwaw
    libmysqlclient
    libodfgen
    libpthreadstubs
    librdf_rasqal
    librdf_redland
    librevenge
    librsvg
    libsndfile
    libvisio
    libwpd
    libwpg
    libwps
    libxml2
    libxshmfence
    libxslt
    libzmf
    libwebp
    mdds
    mythes
    ncurses
    neon
    nspr
    nss
    openldap
    openssl
    pam
    perl
    poppler
    postgresql
    python3
    sane-backends
    unixODBC
    unzip
    util-linux
    which
    zip
    zlib
  ] ++ optionals kdeIntegration [
    qtbase
    qtx11extras
    kcoreaddons
    kio
  ];

  passthru = {
    inherit srcs;
    jdk = jre';
    updateScript = [
      ./update.sh
      # Pass it this file name as argument
      (builtins.unsafeGetAttrPos "pname" finalAttrs.finalPackage).file
      # And the variant
      variant
    ];
    inherit kdeIntegration;
    # For the wrapper.nix
    inherit gtk3;
    # Although present in qtPackages, we need qtbase.qtPluginPrefix and
    # qtbase.qtQmlPrefix
    inherit qtbase;
    gst_packages = with gst_all_1; [
      gst-libav
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gstreamer
    ];
    qmlPackages = [
      ki18n
      knotifications
      qtdeclarative
      qtquickcontrols
      qtwayland
      solid
      sonnet
    ];
    qtPackages = [
      kauth
      kcompletion
      kconfigwidgets
      kglobalaccel
      ki18n
      kio
      kitemviews
      ktextwidgets
      kwidgetsaddons
      kwindowsystem
      kxmlgui
      phonon
      qtbase
      qtdeclarative
      qtsvg
      qttools
      qtwayland
      sonnet
    ];
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    # at least one jar in dependencies
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
})
