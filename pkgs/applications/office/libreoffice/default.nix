{ stdenv
, fetchurl
, lib
, pam
, python3
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
, gnome
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
, langs ? [ "ar" "ca" "cs" "da" "de" "en-GB" "en-US" "eo" "es" "fi" "fr" "hu" "it" "ja" "nl" "pl" "pt" "pt-BR" "ro" "ru" "sk" "sl" "tr" "uk" "zh-CN" ]
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
, dejavu_fonts
, rubik
, liberation-sans-narrow
, liberation_ttf_v2
, libertine
, libertine-g
, noto-fonts
, noto-fonts-cjk-sans
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
}:

assert builtins.elem variant [ "fresh" "still" ];

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

  qtMajor = lib.versions.major qtbase.version;

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

  postUnpack = ''
    mkdir -v $sourceRoot/${tarballPath}

    ${flip concatMapStrings srcs.third_party (f: ''
      ln -sfv ${f} $sourceRoot/${tarballPath}/${f.md5name}
      ln -sfv ${f} $sourceRoot/${tarballPath}/${f.name}
    '')}

    ln -sv ${srcs.help} $sourceRoot/${tarballPath}/${srcs.help.name}
    ln -svf ${srcs.translations} $sourceRoot/${tarballPath}/${srcs.translations.name}

    tar -xf ${srcs.help}
    tar -xf ${srcs.translations}
  '';

  patches = [
    # Skip some broken tests:
    # - tdf160386 does not fall back to a CJK font properly for some reason
    # - the remaining tests have notes in the patch
    # FIXME: get rid of this ASAP
    ./skip-broken-tests.patch
  ] ++ lib.optionals (variant == "still") [
    # Remove build config to reduce the amount of `-dev` outputs in the
    # runtime closure. This behavior was introduced by upstream in commit
    # cbfac11330882c7d0a817b6c37a08b2ace2b66f4
    ./0001-Strip-away-BUILDCONFIG.patch
    # See above
    ./skip-broken-tests-still.patch
  ] ++ lib.optionals (variant == "fresh") [
    # Revert part of https://github.com/LibreOffice/core/commit/6f60670877208612b5ea320b3677480ef6508abb that broke zlib linking
    ./readd-explicit-zlib-link.patch
    # See above
    ./skip-broken-tests-fresh.patch
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
  '';

  nativeBuildInputs = [
    autoconf
    automake
    bison
    fontforge
    gdb
    jdk17
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
    gnome.adwaita-icon-theme
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
    "--with-system-cairo"
    "--with-system-libs"
    "--with-system-headers"
    "--with-system-openssl"
    "--with-system-libabw"
    "--with-system-liblangtag"
    "--without-system-libcmis"
    "--with-system-libwps"
    "--with-system-mdds"
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
    "--without-system-frozen"
    "--without-system-lpsolve"
    "--without-system-libfreehand"
    "--without-system-libmspub"
    "--without-system-libnumbertext"
    "--without-system-libpagemaker"
    "--without-system-libstaroffice"
    "--without-system-libqxp"
    "--without-system-dragonbox"
    "--without-system-libfixmath"

    # is packaged but headers can't be found because there is no pkg-config file
    "--without-system-zxcvbn"

    "--with-system-orcus"
    "--with-system-libepubgen"
    "--with-system-libetonyek"
    "--without-system-xmlsec"
    "--without-system-zxing"
  ] ++ optionals kdeIntegration [
    "--enable-kf${qtMajor}"
    "--enable-qt${qtMajor}"
  ] ++ optionals (kdeIntegration && qtMajor == "5") [
    "--enable-gtk3-kde5"
  ];


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

  doCheck = true;

  preCheck = ''
    export HOME=$(pwd)
  '';

  checkTarget = concatStringsSep " " [
    "unitcheck"
    "slowcheck"
    "--keep-going"  # easier to debug test failures
  ];

  postInstall = ''
    mkdir -p $out/share/icons

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
  };
})
