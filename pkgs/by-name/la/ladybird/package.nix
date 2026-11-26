{
  lib,
  stdenv,
  apple-sdk_26,
  darwin,
  darwinMinVersionHook,
  cacert,
  callPackage,
  fetchFromGitHub,
  pdfjs,
  chromium-hsts-preload-list,
  cmake,
  gitMinimal,
  ninja,
  pkg-config,
  curlFull, # Websocket support
  libavif,
  libicns,
  angle, # libEGL
  brotli,
  cpptrace,
  dbus,
  elfutils,
  glib,
  glslang,
  harfbuzz,
  libdrm,
  libGL,
  libjpeg_turbo,
  libpng,
  libpsl,
  libedit,
  libpulseaudio,
  libwebp,
  mimalloc,
  openssl,
  python3,
  qt6Packages,
  woff2,
  wuffs,
  cargo,
  fast-float,
  ffmpeg,
  fontconfig,
  rustPlatform,
  rustc,
  makeWrapper,
  simdutf,
  skia,
  nixosTests,
  nix-update-script,
  sdl3,
  icu78,
  simdjson,
  sqlite,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  zlib,
  zmij,
}:

let
  llvmLibcHeaders = callPackage ./llvm-libc-headers.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "2026.48.0";

  src = fetchFromGitHub {
    owner = "LadybirdBrowser";
    repo = "ladybird";
    tag = finalAttrs.version;
    hash = "sha256-NZS7qNTEQApDSt4/AQg5cCVJeO7PWA4JPzLmIhykgeE=";
    nativeBuildInputs = [ gitMinimal ];
    # Keep the commit shown in About Ladybird when building from an archive.
    postFetch = ''
      gzip -dc "$renamed" | {
        git get-tar-commit-id > "$out/REVISION" || exit 1
        cat > /dev/null
      }
    '';
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-v8/n/wo1gOy9e3qBtbdrYdgiW8FOPPz1xoIpBxB4s7E=";
  };

  patches =
    lib.optionals stdenv.hostPlatform.isLinux [
      ./patches/linux-native-egl.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # https://github.com/LadybirdBrowser/ladybird/issues/11891
      ./patches/darwin-build.patch
    ];

  postPatch = ''
    sed -i '/iconutil/d' UI/CMakeLists.txt

    # https://github.com/LadybirdBrowser/ladybird/pull/12751
    # New Rust releases can deprecate APIs used by this snapshot.
    substituteInPlace Meta/CMake/rust_crate.cmake \
      --replace-fail 'set(RUSTC_TARGET_FLAGS -Dwarnings ' 'set(RUSTC_TARGET_FLAGS '

    # Use nixpkgs' FFmpeg without the suffix used by Ladybird's bundled copy.
    substituteInPlace Meta/CMake/check_for_dependencies.cmake \
      --replace-fail libavcodec-ladybird libavcodec \
      --replace-fail libavutil-ladybird libavutil \
      --replace-fail libswresample-ladybird libswresample

    # Install the same PDF viewer assets and integration patch as the vcpkg build.
    cp -r ${pdfjs}/share/pdf.js pdfjs
    chmod -R u+w pdfjs
    patch -d pdfjs -p1 < Meta/CMake/vcpkg/overlay-ports/pdfjs/0001-ladybird-embed.patch

    # Don't set absolute paths in RPATH
    substituteInPlace Meta/CMake/lagom_install_options.cmake \
      --replace-fail "\''${CMAKE_INSTALL_BINDIR}" "bin" \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}" "lib"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # FFmpeg is opened with dlopen, so Nix's RPATH shrinker drops its directories.
    substituteInPlace Libraries/LibMediaCodecs/CMakeLists.txt \
      --replace-fail "\''${LADYBIRD_BUNDLED_AVCODEC_SONAME}" '$<TARGET_FILE:BundledFFmpeg::AVCODEC>' \
      --replace-fail "\''${LADYBIRD_BUNDLED_LIBSWRESAMPLE_SONAME}" '$<TARGET_FILE:BundledFFmpeg::LIBSWRESAMPLE>'

    substituteInPlace Services/Compositor/main.cpp \
      --replace-fail '@NIX_NATIVE_EGL@' '${lib.getLib libGL}/lib/libEGL.so.1'
    substituteInPlace Libraries/LibSandbox/GpuDriverPaths.cpp \
      --replace-fail '@NIX_DRIVER_LINK@' '${libGL.driverLink}' \
      --replace-fail '@NIX_STORE_DIR@' '${builtins.storeDir}'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Services/RequestServer/main.cpp \
      --replace-fail '@NIX_CA_BUNDLE@' '${cacert}/etc/ssl/certs/ca-bundle.crt'
  '';

  preConfigure = ''
    # Use upstream's PDF.js discovery with our patched distribution.
    cmakeFlagsArray+=("-DPDFJS_DIR=$PWD/pdfjs")

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
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    qt6Packages.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ glslang ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
    libicns
    darwin.sigtool
  ];

  buildInputs = [
    curlFull
    brotli
    cpptrace
    fast-float
    ffmpeg
    fontconfig
    harfbuzz
    libavif
    angle # libEGL
    libGL
    libjpeg_turbo
    libpng
    libpsl
    libedit
    libwebp
    llvmLibcHeaders
    (mimalloc.overrideAttrs (prev: {
      # Ladybird uses heap APIs removed in mimalloc 3.
      version = "2.2.7";
      src = fetchFromGitHub {
        owner = "microsoft";
        repo = "mimalloc";
        tag = "v2.2.7";
        hash = "sha256-z9qMOTcGkURblZChXDGfQ58hrql52lG6EE1NQmxxuj0=";
      };
      # Upstream disables block padding to avoid inflating allocation size classes.
      cmakeFlags = prev.cmakeFlags ++ [ (lib.cmakeBool "MI_NO_PADDING" true) ];
    }))
    openssl
    qt6Packages.qtbase
    sdl3
    simdutf
    (skia.overrideAttrs (prev: {
      # Ladybird also uses Skia's color management API directly.
      gnFlags = prev.gnFlags ++ [
        "extra_cflags+=[\"-DSKCMS_DLL\"]"
      ];
      postInstall =
        (prev.postInstall or "")
        + lib.optionalString stdenv.hostPlatform.isDarwin ''
          # Ladybird's native font loader uses SkTypeface_Mac::MakeFromStream.
          install -Dm644 ../../src/ports/SkTypeface_mac_ct.h \
            $out/include/skia/src/ports/SkTypeface_mac_ct.h
          install -Dm644 ../../src/utils/mac/SkUniqueCFRef.h \
            $out/include/skia/src/utils/mac/SkUniqueCFRef.h
        '';
    }))
    wuffs
    woff2
    icu78
    simdjson
    sqlite
    zlib
    zmij
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    elfutils
    libpulseaudio
    glib
    libdrm
    qt6Packages.qtpositioning
    qt6Packages.qtsvg
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
    # Disable network operations
    "-DENABLE_NETWORK_DOWNLOADS=OFF"
    # Nix manages updates. This also disables Sparkle on macOS.
    (lib.cmakeBool "LADYBIRD_ENABLE_UPDATE_CHECK" false)
    (lib.cmakeFeature "LADYBIRD_VERSION" finalAttrs.version)
    # Ladybird requires icu 78, but without this flag the default icu
    # from other dependencies gets picked up instead.
    (lib.cmakeFeature "ICU_ROOT" (toString icu78.dev))
    # Upstream defaults to -Ctarget-cpu=native for Rust, which cc-wrapper
    # cannot strip; target a portable baseline instead.
    (lib.cmakeBool "LADYBIRD_BASELINE_CPU_TARGET" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/bundle/Ladybird.app $out/Applications
    png2icns "$out/Applications/Ladybird.app/Contents/Resources/app_icon.icns" \
      ${finalAttrs.src}/UI/Icons/macos/app_icon.iconset/icon_{16x16,32x32,128x128,256x256,512x512,512x512@2x}.png
    makeWrapper "$out/Applications/Ladybird.app/Contents/MacOS/Ladybird" "$out/bin/Ladybird"
  '';

  # Restore per-process entitlements after stripping and other fixups, then seal the bundle.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for entitlements in Services/*/*.entitlements; do
      case "$entitlements" in
        *.release.entitlements) continue ;;
      esac
      helper=$(basename "$entitlements" .entitlements)
      codesign --force --sign - --options runtime --entitlements "$entitlements" \
        "$out/Applications/Ladybird.app/Contents/MacOS/$helper"
    done
    codesign --force --sign - --entitlements ${finalAttrs.src}/Meta/Entitlements.plist \
      "$out/Applications/Ladybird.app/Contents/MacOS/Ladybird"
    codesign --force --sign - --preserve-metadata=entitlements,flags \
      "$out/Applications/Ladybird.app"
  '';

  # Only Ladybird and WebContent need wrapped, if Qt is enabled.
  # On linux we end up wrapping some non-Qt apps, like headless-browser.
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Browser using the SerenityOS LibWeb engine with a Qt GUI";
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
