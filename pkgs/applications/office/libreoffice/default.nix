{ stdenv
, fetchurl
, fetchgit
, fetchpatch2
, lib
, pam
, python311
, libxslt
, perl
, perlPackages
, box2d
, gettext
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
, jdk21
, ant
, cups
, xorg
, fontforge
, jre21_minimal
, openssl
, gperf
, cppunit
, poppler
, util-linux
, librsvg
, libGLU
, libGL
, bsh
, coinmp
, libwps
, libabw
, libargon2
, libmysqlclient
, autoconf
, automake
, openldap
, bash
, hunspell
, librdf_rasqal
, librdf_redland
, nss
, nspr
, libwpg
, dbus-glib
, clucene_core_2
, libcdr
, lcms2
, unixODBC
, mdds
, sane-backends
, mythes
, libexttextcat
, libvisio
, pkg-config
, bluez5
, libtool
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
, adwaita-icon-theme
, glib
, ncurses
, libepoxy
, gpgme
, libwebp
, abseil-cpp
, libepubgen
, libetonyek
, liborcus
, libpng
, langs ? [ "ar" "ca" "cs" "da" "de" "en-GB" "en-US" "eo" "es" "fi" "fr" "hu" "it" "ja" "ko" "nl" "pl" "pt" "pt-BR" "ro" "ru" "sk" "sl" "tr" "uk" "zh-CN" "zh-TW" ]
, withFonts ? false
, withHelp ? true
, kdeIntegration ? false
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
, makeFontsConf
, amiri
, caladea
, carlito
, culmus
, dejavu_fonts
, rubik
, liberation-sans-narrow
, liberation_ttf_v2
, libertine
, libertine-g
, noto-fonts
, noto-fonts-cjk-sans
, rhino
, lp_solve
, xmlsec
, libcmis
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
, qtmultimedia ? null
, qtquickcontrols ? null
, qtsvg ? null
, qttools ? null
, solid ? null
, sonnet ? null
}:

assert builtins.elem variant [ "fresh" "still" "collabora" ];

let
  inherit (lib)
    flatten flip
    concatMapStrings concatStringsSep
    getDev getLib
    optionals optionalString;

  fontsConf = makeFontsConf {
    fontDirectories = [
      amiri
      caladea
      carlito
      culmus
      dejavu_fonts
      rubik
      liberation-sans-narrow
      liberation_ttf_v2
      libertine
      libertine-g
      noto-fonts
      noto-fonts-cjk-sans
    ];
  };

  jre' = jre21_minimal.override {
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
    translations = srcsAttributes.translations { inherit fetchurl fetchgit; };
    help = srcsAttributes.help { inherit fetchurl fetchgit; };
  };

  qtMajor = lib.versions.major qtbase.version;

  # See `postPatch` for details
  kdeDeps = symlinkJoin {
    name = "libreoffice-kde-dependencies-${version}";
    paths = flatten (map (e: [ (getDev e) (getLib e) ]) [
      qtbase
      qtmultimedia
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

  src = srcsAttributes.main { inherit fetchurl fetchgit; };

  postUnpack = ''
    mkdir -v $sourceRoot/${tarballPath}

    ${flip concatMapStrings srcs.third_party (f: ''
      ln -sfv ${f} $sourceRoot/${tarballPath}/${f.md5name}
      ln -sfv ${f} $sourceRoot/${tarballPath}/${f.name}
    '')}

  '' + (if (variant != "collabora") then ''
    ln -sv ${srcs.help} $sourceRoot/${tarballPath}/${srcs.help.name}
    ln -svf ${srcs.translations} $sourceRoot/${tarballPath}/${srcs.translations.name}

    tar -xf ${srcs.help}
    tar -xf ${srcs.translations}
  '' else ''
    cp -r --no-preserve=mode ${srcs.help}/. $sourceRoot/helpcontent2/
    cp -r --no-preserve=mode ${srcs.translations}/. $sourceRoot/translations/
  '');

  patches = [
    # Skip some broken tests:
    # - tdf160386 does not fall back to a CJK font properly for some reason
    # - the remaining tests have notes in the patches
    # FIXME: get rid of this ASAP
    ./skip-broken-tests.patch
    (./skip-broken-tests- + variant + ".patch")

    # Don't detect Qt paths from qmake, so our patched-in onese are used
    ./dont-detect-qt-paths-from-qmake.patch

    # Revert part of https://github.com/LibreOffice/core/commit/6f60670877208612b5ea320b3677480ef6508abb that broke zlib linking
    ./readd-explicit-zlib-link.patch
  ] ++ lib.optionals (lib.versionOlder version "24.8") [
    (fetchpatch2 {
      name = "icu74-compat.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libreoffice-fresh/-/raw/main/libreoffice-7.5.8.2-icu-74-compatibility.patch?ref_type=heads.patch";
      hash = "sha256-OGBPIVQj8JTYlkKywt4QpH7ULAzKmet5jTLztGpIS0Y=";
    })
  ] ++ lib.optionals (variant == "collabora") [
    ./fix-unpack-collabora.patch
  ];

  postPatch = ''
    # configure checks for header 'gpgme++/gpgmepp_version.h',
    # and if it is found (no matter where) uses a hardcoded path
    # in what presumably is an effort to make it possible to write
    # '#include <context.h>' instead of '#include <gpgmepp/context.h>'.
    #
    # Fix this path to point to where the headers can actually be found instead.
    substituteInPlace configure.ac --replace-fail \
      'GPGMEPP_CFLAGS=-I/usr/include/gpgme++' \
      'GPGMEPP_CFLAGS=-I${gpgme.dev}/include/gpgme++'

    # Fix for Python 3.12
    substituteInPlace configure.ac --replace-fail distutils.sysconfig sysconfig
  '';

  nativeBuildInputs = [
    autoconf
    automake
    bison
    fontforge
    gdb
    jdk21
    libtool
    pkg-config
  ];

  buildInputs = finalAttrs.passthru.gst_packages ++ [
    # Make libpng not handle APNG images, so LibreOffice's own handler kicks in
    # This should be ordered first, so it gets picked up before any other
    # propagated libpng
    # See: https://www.mail-archive.com/libreoffice@lists.freedesktop.org/msg334080.html
    (libpng.override { apngSupport = false; })
    perlPackages.ArchiveZip
    coinmp
    perlPackages.IOCompress
    abseil-cpp
    ant
    bluez5
    boost
    box2d
    cairo
    clucene_core_2
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
    adwaita-icon-theme
    gperf
    gpgme
    graphite2
    gtk3
    (harfbuzz.override { withIcu = true; })
    hunspell
    icu
    jre'
    lcms2
    libGL
    libGLU
    xorg.libX11
    xorg.libXaw
    xorg.libXdmcp
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXtst
    libabw
    libargon2
    libatomic_ops
    libcdr
    libcmis
    libe-book
    libepoxy
    libepubgen
    libetonyek
    libexttextcat
    libjpeg
    liblangtag
    libmspack
    libmwaw
    libmysqlclient
    libodfgen
    liborcus
    xorg.libpthreadstubs
    librdf_redland
    librevenge
    librsvg
    libsndfile
    libvisio
    libwpd
    libwpg
    libwps
    libxml2
    xorg.libxshmfence
    libxslt
    libzmf
    libwebp
    lp_solve
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
    python311
    sane-backends
    unixODBC
    unzip
    util-linux
    which
    xmlsec
    zip
    zlib
  ] ++ optionals kdeIntegration [
    qtbase
    qtx11extras
    kcoreaddons
    kio
  ];

  preConfigure = ''
    configureFlagsArray=(
      "--with-parallelism=$NIX_BUILD_CORES"
      # here because we need to be very specific about spaces
      "--with-lang=${concatStringsSep " " langs}"
    );

    patchShebangs .

    NOCONFIGURE=1 ./autogen.sh
  '' + optionalString kdeIntegration ''
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
    export QT${qtMajor}INC=${kdeDeps}/include
    export QT${qtMajor}LIB=${kdeDeps}/lib
    export KF${qtMajor}INC="${kdeDeps}/include ${kdeDeps}/include/KF${qtMajor}"
    export KF${qtMajor}LIB=${kdeDeps}/lib
  '';

  configureFlags = [
    # Explicitly passing in --host even on non-cross, because
    # LibreOffice will attempt to detect WSL and cross-compile
    # itself to Windows automatically, and we don't want it
    # doing that.
    "--host=${stdenv.hostPlatform.config}"
    "--without-buildconfig-recorded"

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
    (lib.withFeature withFonts "fonts")
    "--without-doxygen"

    "--with-system-beanshell"
    "--with-system-cairo"
    "--with-system-coinmp"
    "--with-system-headers"
    "--with-system-libabw"
    "--with-system-libcmis"
    "--with-system-libepubgen"
    "--with-system-libetonyek"
    "--with-system-liblangtag"
    "--with-system-libs"
    "--with-system-libwps"
    "--with-system-lpsolve"
    "--with-system-mdds"
    "--with-system-openldap"
    "--with-system-openssl"
    "--with-system-orcus"
    "--with-system-postgresql"
    "--with-system-xmlsec"

    # TODO: package these as system libraries
    "--without-system-altlinuxhyph"
    "--without-system-frozen"
    "--without-system-libfreehand"
    "--without-system-libmspub"
    "--without-system-libnumbertext"
    "--without-system-libpagemaker"
    "--without-system-libstaroffice"
    "--without-system-libqxp"
    "--without-system-dragonbox"
    "--without-system-libfixmath"

    # requires an oddly specific, old version
    "--without-system-hsqldb"

    # searches hardcoded paths that are wrong
    "--without-system-zxing"

    # is packaged but headers can't be found because there is no pkg-config file
    "--without-system-zxcvbn"
  ] ++ optionals kdeIntegration [
    "--enable-kf${qtMajor}"
    "--enable-qt${qtMajor}"
  ] ++ optionals (kdeIntegration && qtMajor == "5") [
    "--enable-gtk3-kde5"
  ] ++ (if variant == "fresh" then [
    "--with-system-rhino"
    "--with-rhino-jar=${rhino}/share/java/js.jar"
  ] else [
    # our Rhino is too new for older versions
    "--without-system-rhino"
  ]);


  env = {
    # FIXME: this is a hack, because the right cflags are not being picked up
    # from rasqal's .pc file. Needs more investigation.
    NIX_CFLAGS_COMPILE = "-I${librdf_rasqal}/include/rasqal";

    # Provide all the fonts used in tests.
    FONTCONFIG_FILE = fontsConf;
  };

  makeFlags = [ "SHELL=${bash}/bin/bash" ];

  enableParallelBuilding = true;

  buildTargets = [ "build-nocheck" ];

  # Disable tests for the Qt5 build, as they seem even more flaky
  # than usual, and we will drop the Qt5 build after 24.11 anyway.
  doCheck = !(kdeIntegration && qtMajor == "5");

  preCheck = ''
    export HOME=$(pwd)
  '';

  checkTarget = concatStringsSep " " [
    "unitcheck"
    "slowcheck"
    "--keep-going"  # easier to debug test failures
  ];

  postInstall = optionalString (variant != "collabora") ''
    mkdir -p $out/{include,share/icons}

    cp -r include/LibreOfficeKit $out/include/
    cp -r sysui/desktop/icons/hicolor $out/share/icons

    # Rename icons for consistency
    for file in $out/share/icons/hicolor/*/apps/*; do
      mv $file "$(dirname $file)/libreoffice-$(basename $file)"
    done

    ln -s $out/lib/libreoffice/share/xdg $out/share/applications

    # Unversionize desktop files
    . ./bin/get_config_variables PRODUCTVERSION
    for file in $out/lib/libreoffice/share/xdg/*.desktop; do
      substituteInPlace $file \
        --replace-fail "LibreOffice $PRODUCTVERSION" "LibreOffice" \
        --replace-warn "Icon=libreoffice$PRODUCTVERSION" "Icon=libreoffice" \
        --replace-fail "Exec=libreoffice$PRODUCTVERSION" "Exec=libreoffice"
    done
  '';

  # Wrapping is done in ./wrapper.nix
  dontWrapQtApps = true;

  passthru = {
    inherit srcs;
    jdk = jre';
    python = python311; # for unoconv
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
      qtmultimedia
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
      qtmultimedia
      qtsvg
      qttools
      qtwayland
      sonnet
    ];
  };

  # libreoffice tries to reference the BUILDCONFIG (e.g. PKG_CONFIG_PATH)
  # in the binary causing the closure size to blow up because of many unnecessary
  # dependencies to dev outputs. This behavior was patched away in nixpkgs
  # (see above), make sure these don't leak again by accident.
  # FIXME: disabled for kdeIntegration builds because the weird symlinkJoin setup
  # leaks all the -dev dependencies :(
  disallowedRequisites = lib.optionals (!kdeIntegration) (lib.concatMap (x: lib.optional (x?dev) x.dev) finalAttrs.buildInputs);

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    changelog = "https://wiki.documentfoundation.org/ReleaseNotes/${lib.versions.majorMinor version}";
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    # at least one jar in dependencies
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    mainProgram = "libreoffice";
  };
})
