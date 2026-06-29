{
  lib,
  stdenv,
  fetchFromGitea,
  testers,
  writeShellApplication,
  alsa-lib,
  autoconf,
  cairo,
  common-updater-scripts,
  curl,
  dbus,
  dbus-glib,
  desktop-file-utils,
  ffmpeg,
  fontconfig,
  freetype,
  gnum4,
  gtk2,
  gtk3,
  libGL,
  libGLU,
  libevent,
  libnotify,
  libpulseaudio,
  libstartup_notification,
  libx11,
  libxext,
  libxft,
  libxi,
  libxml2,
  libxrender,
  libxscrnsaver,
  libxt,
  nasm,
  pango,
  perl,
  pixman,
  pkg-config,
  python3,
  unzip,
  which,
  wrapGAppsHook3,
  xorgproto,
  yasm,
  zip,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "palemoon";
  version = "34.3.1";

  src = fetchFromGitea {
    domain = "repo.palemoon.org";
    owner = "MoonchildProductions";
    repo = "Pale-Moon";
    rev = "${finalAttrs.version}_Release";
    fetchSubmodules = true;
    hash = "sha256-0RvY1iw5pL4KlEUEe2omaF7TVkcn/D5sw4OjciT7Jys=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    desktop-file-utils
    gnum4
    nasm
    perl
    pkg-config
    python3
    unzip
    which
    wrapGAppsHook3
    yasm
    zip
  ];

  buildInputs = [
    alsa-lib
    cairo
    dbus
    dbus-glib
    ffmpeg
    fontconfig
    freetype
    gtk2
    gtk3
    libGL
    libGLU
    libevent
    libnotify
    libpulseaudio
    libstartup_notification
    libx11
    libxext
    libxft
    libxi
    libxrender
    libxscrnsaver
    libxt
    pango
    pixman
    xorgproto
    zlib
  ];

  # Manual
  dontWrapGApps = true;

  postPatch = ''
    patchShebangs ./mach
  '';

  configurePhase = ''
    runHook preConfigure

    # Too many cores can lead to build flakiness
    # https://forum.palemoon.org/viewtopic.php?f=5&t=28480
    export jobs=$(($NIX_BUILD_CORES<=16 ? $NIX_BUILD_CORES : 16))
    if [ -z "$enableParallelBuilding" ]; then
      jobs=1
    fi

    export MOZCONFIG=$PWD/mozconfig
    export MOZ_NOSPAM=1

    export build64=${lib.optionalString stdenv.hostPlatform.is64bit "1"}
    export gtkversion="3"
    export xlibs=${lib.makeLibraryPath [ libx11 ]}
    export prefix=$out
    export mozmakeflags="-j$jobs"
    export autoconf=${autoconf}/bin/autoconf

    substituteAll ${./mozconfig} $MOZCONFIG

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    ./mach build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./mach install

    # Install official branding stuff
    desktop-file-install --dir=$out/share/applications \
      ./palemoon/branding/official/palemoon.desktop
    for iconname in default{16,22,24,32,48,256} mozicon128; do
      n=''${iconname//[^0-9]/}
      size=$n"x"$n
      install -Dm644 ./palemoon/branding/official/$iconname.png $out/share/icons/hicolor/$size/apps/palemoon.png
    done

    # Remove unneeded SDK data from installation
    # https://forum.palemoon.org/viewtopic.php?f=37&t=26796&p=214676#p214729
    rm -r $out/{include,share/idl,lib/palemoon-devel-${finalAttrs.version}}

    runHook postInstall
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath [
        ffmpeg
        libGL
        libpulseaudio
      ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${libPath}"
      )
      wrapGApp $out/lib/palemoon-${finalAttrs.version}/palemoon
    '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = lib.getExe (writeShellApplication {
      name = "update-palemoon";
      runtimeInputs = [
        common-updater-scripts
        curl
        libxml2
      ];
      text = ''
        # Only release note announcement == finalized release
        version="$(
          curl -s 'http://www.palemoon.org/releasenotes.shtml' |
          xmllint --html --xpath 'html/body/table/tbody/tr/td/h3/text()' - 2>/dev/null | head -n1 |
          sed 's/v\(\S*\).*/\1/'
        )"
        update-source-version ${finalAttrs.pname} "$version"
      '';
    });
  };

  meta = {
    homepage = "https://www.palemoon.org/";
    description = "An Open Source, Goanna-based web browser focusing on efficiency and customization";
    longDescription = ''
      Pale Moon is an Open Source, Goanna-based web browser focusing on
      efficiency and customization.

      Pale Moon offers you a browsing experience in a browser completely built
      from its own, independently developed source that has been forked off from
      Firefox/Mozilla code a number of years ago, with carefully selected
      features and optimizations to improve the browser's stability and user
      experience, while offering full customization and a growing collection of
      extensions and themes to make the browser truly your own.
    '';
    changelog = "https://repo.palemoon.org/MoonchildProductions/Pale-Moon/releases/tag/${finalAttrs.version}_Release";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      OPNA2608
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    # Only specific GCC versions are supported with branding
    # https://developer.palemoon.org/build/linux/
    # assert breaks PR eval on GitHub CI :(
    broken =
      !(
        stdenv.cc.isGNU
        && lib.strings.versionAtLeast stdenv.cc.version "9"
        && lib.strings.versionOlder stdenv.cc.version "16"
      );
  };
})
