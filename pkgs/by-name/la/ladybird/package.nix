{
  lib,
  stdenv,
  apple-sdk_26,
  darwinMinVersionHook,
  cacert,
  fetchFromGitHub,
  fetchzip,
  pdfjs,
  chromium-hsts-preload-list,
  cmake,
  gitMinimal,
  ninja,
  pkg-config,
  curlFull, # Websocket support
  libavif,
  angle, # libEGL
  brotli,
  cpptrace,
  glib,
  glslang,
  harfbuzz,
  libdrm,
  libGL,
  libjpeg_turbo,
  libpng,
  libpsl,
  libxml2,
  libedit,
  libpulseaudio,
  libwebp,
  mimalloc,
  openssl,
  perl,
  python3,
  qt6Packages,
  woff2,
  wuffs,
  cargo,
  fast-float,
  ffmpeg,
  fmt,
  fontconfig,
  rustPlatform,
  rustc,
  rcodesign,
  makeWrapper,
  simdutf,
  skia,
  nixosTests,
  unstableGitUpdater,
  _experimental-update-script-combinators,
  common-updater-scripts,
  libtommath,
  sdl3,
  icu78,
  simdjson,
  sqlite,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  zlib,
}:

let
  # The integration patch shipped by Ladybird targets this PDF.js version.
  pdfjsForLadybird = pdfjs.overrideAttrs (
    final: _prev: {
      version = "5.6.205";
      src = fetchzip {
        url = "https://github.com/mozilla/pdf.js/releases/download/v${final.version}/pdfjs-${final.version}-dist.zip";
        hash = "sha256-JMmxoT68PNJ/MmlMwVNYcHerorklLv5YY6C55xjn73w=";
        stripRoot = false;
      };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "LadybirdBrowser";
    repo = "ladybird";
    rev = "b90af890b56cbd51c452d929fe71abcb8adaa36f";
    hash = "sha256-hLo6Z4Q2tzkPlkPR+C6CxTjRvQZUAgpj6OB4wJFU+RY=";
    # Normalize case-colliding test directories before hashing the source.
    # https://github.com/LadybirdBrowser/ladybird/issues/12123
    postFetch = ''
      for parent in "$out"/Tests/LibWeb/Text/{input,expected}; do
        mkdir "$parent/canvas-normalized"
        for directory in "$parent"/[Cc]anvas; do
          find "$directory" -mindepth 1 -maxdepth 1 \
            -exec mv --no-clobber -t "$parent/canvas-normalized" -- {} +
          rmdir "$directory"
        done
        mv "$parent/canvas-normalized" "$parent/canvas"
      done
    '';
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-UshQ0YBl5TLbrEanqsNVeXgONYEux2bgBhI4ISby0Qc=";
  };

  patches = [
    # https://github.com/LadybirdBrowser/ladybird/issues/11772
    ./build-information-source-archive.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/LadybirdBrowser/ladybird/issues/11875
    # https://github.com/LadybirdBrowser/ladybird/issues/11891
    ./darwin-build.patch
  ];

  postPatch = ''
    sed -i '/iconutil/d' UI/CMakeLists.txt

    perl -0pi -e \
      's/find_package\(ICU 78\.[0-9]+ EXACT REQUIRED COMPONENTS data i18n uc\)/find_package(ICU ${icu78.version} EXACT REQUIRED COMPONENTS data i18n uc)/ or die "ICU dependency not found\n"' \
      Meta/CMake/check_for_dependencies.cmake

    # Install the same PDF viewer assets and integration patch as the vcpkg build.
    cp -r ${pdfjsForLadybird}/share/pdf.js pdfjs
    chmod -R u+w pdfjs
    patch -d pdfjs -p1 < Meta/CMake/vcpkg/overlay-ports/pdfjs/0001-ladybird-embed.patch
    substituteInPlace UI/cmake/ResourceFiles.cmake \
      --replace-fail 'if (NOT "''${VCPKG_INSTALLED_DIR}" STREQUAL "" AND NOT "''${VCPKG_TARGET_TRIPLET}" STREQUAL "")' 'if (TRUE)' \
      --replace-fail '"''${VCPKG_INSTALLED_DIR}/''${VCPKG_TARGET_TRIPLET}/share/pdfjs"' '"''${LADYBIRD_SOURCE_DIR}/pdfjs"'

    # Don't set absolute paths in RPATH
    substituteInPlace Meta/CMake/lagom_install_options.cmake \
      --replace-fail "\''${CMAKE_INSTALL_BINDIR}" "bin" \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}" "lib"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Services/RequestServer/main.cpp \
      --replace-fail '@NIX_CA_BUNDLE@' '${cacert}/etc/ssl/certs/ca-bundle.crt'
  '';

  preConfigure = ''
    # HSTS preload data is the only remaining downloaded data cache.
    mkdir -p build/Caches
    cmakeFlagsArray+=("-DLADYBIRD_CACHE_DIR=$PWD/build/Caches")

    mkdir build/Caches/HSTSPreload
    cp ${chromium-hsts-preload-list}/share/chromium-hsts-preload-list/transport_security_state_static.json build/Caches/HSTSPreload
  '';

  nativeBuildInputs = [
    cargo
    cmake
    gitMinimal
    ninja
    perl
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    qt6Packages.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ glslang ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
    rcodesign
  ];

  buildInputs = [
    curlFull
    brotli
    cpptrace
    fast-float
    ffmpeg
    fmt
    fontconfig
    harfbuzz
    libavif
    angle # libEGL
    libGL
    libjpeg_turbo
    libpng
    libpsl
    libtommath
    libxml2
    libedit
    libwebp
    (mimalloc.overrideAttrs {
      # Ladybird uses heap APIs removed in mimalloc 3.
      version = "2.2.7";
      src = fetchFromGitHub {
        owner = "microsoft";
        repo = "mimalloc";
        tag = "v2.2.7";
        hash = "sha256-z9qMOTcGkURblZChXDGfQ58hrql52lG6EE1NQmxxuj0=";
      };
    })
    openssl
    qt6Packages.qtbase
    qt6Packages.qtpositioning
    sdl3
    simdutf
    (skia.overrideAttrs (prev: {
      # Ladybird also uses Skia's color management API directly.
      gnFlags = prev.gnFlags ++ [
        "extra_cflags+=[\"-DSKCMS_DLL\"]"
      ];
    }))
    (wuffs.overrideAttrs (prev: {
      # Ladybird includes the stable 0.3 single-file library.
      version = "0.3.4";
      vendorHash = "sha256-CRzsGHE3K/WWPX0A3B1CvvEdADlxdIhaT5fOtaA3LPo=";
      src = fetchFromGitHub {
        owner = "google";
        repo = "wuffs";
        tag = "v0.3.4";
        hash = "sha256-XiaHus+bZ4jAk2zwinzz7VzyThCNlx36Auqyw2OH5rM=";
      };
      postInstall =
        lib.replaceStrings
          [ "release/c/wuffs-unsupported-snapshot.c" "wuffs-v0.4.c" ]
          [ "release/c/wuffs-v0.3.c" "wuffs-v0.3.c" ]
          prev.postInstall;
    }))
    woff2
    icu78
    simdjson
    sqlite
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio.dev
    glib
    libdrm
    qt6Packages.qtwayland
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_26
    (darwinMinVersionHook "14.0")
  ];

  cmakeFlags = [
    # Takes an enormous amount of resources, even with mold
    (lib.cmakeBool "ENABLE_LTO_FOR_RELEASE" false)
    # Disable network operations
    "-DENABLE_NETWORK_DOWNLOADS=OFF"
    # Ladybird requires icu 78, but without this flag the default icu
    # from other dependencies gets picked up instead.
    (lib.cmakeFeature "ICU_ROOT" (toString icu78.dev))
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
  ];

  # FIXME: Add an option to -DENABLE_QT=ON on macOS to use Qt rather than Cocoa for the GUI

  # ld: [...]/OESVertexArrayObject.cpp.o: undefined reference to symbol 'glIsVertexArrayOES'
  # ld: [...]/libGL.so.1: error adding symbols: DSO missing from command line
  # https://github.com/LadybirdBrowser/ladybird/issues/371#issuecomment-2616415434
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-lGL " + "-lfontconfig";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/bundle/Ladybird.app $out/Applications
    makeWrapper "$out/Applications/Ladybird.app/Contents/MacOS/Ladybird" "$out/bin/Ladybird"
  '';

  # Sign the complete bundle after stripping and other fixups, preserving entitlements.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rcodesign sign \
      --entitlements-xml-file ${finalAttrs.src}/Meta/Entitlements.plist \
      "$out/Applications/Ladybird.app"
  '';

  # Only Ladybird and WebContent need wrapped, if Qt is enabled.
  # On linux we end up wrapping some non-Qt apps, like headless-browser.
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  passthru.updateScript =
    let
      updateSource = unstableGitUpdater {
        hardcodeZeroVersion = true;
      };

      updateCargoDeps = {
        command = [
          (lib.getExe' common-updater-scripts "update-source-version")
          "ladybird"
          "--ignore-same-version"
          "--source-key=cargoDeps.vendorStaging"
        ];
      };
    in
    _experimental-update-script-combinators.sequence [
      updateSource
      updateCargoDeps
    ];

  meta = {
    description = "Browser using the SerenityOS LibWeb engine with a Qt or Cocoa GUI";
    homepage = "https://ladybird.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      fgaz
      jk
      schembriaiden
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "Ladybird";
  };
})
