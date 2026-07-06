{
  lib,
  stdenv,
  fetchFromGitHub,
  cacert,
  unicode-emoji,
  unicode-character-database,
  unicode-idna,
  publicsuffix-list,
  chromium-hsts-preload-list,
  cmake,
  makeWrapper,
  ninja,
  pkg-config,
  curlFull, # Websocket support
  libavif,
  angle, # libEGL
  libjxl,
  libedit,
  libpulseaudio,
  libwebp,
  libxcrypt,
  mimalloc,
  openssl,
  perl,
  python3,
  qt6Packages,
  woff2,
  cargo,
  fast-float,
  ffmpeg,
  fmt,
  fontconfig,
  rustPlatform,
  rustc,
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
  fetchzip,
  glslang,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
}:

let
  # Ladybird's GIFLoader.cpp does `#include <wuffs/wuffs-v0.3.c>`, and its CMake
  # requires the `wuffs/wuffs-v0.3.c` header specifically (pinned to wuffs 0.3.4
  # via vcpkg.json). The nixpkgs `wuffs` package tracks 0.4.x, which installs an
  # incompatible `wuffs-v0.4.c` header, so we vendor just the single-file 0.3.4
  # header on the include path, mirroring Ladybird's own vcpkg overlay-port.
  wuffsHeader = fetchzip {
    url = "https://github.com/google/wuffs-mirror-release-c/archive/refs/tags/v0.3.4.tar.gz";
    hash = "sha256-V7inWJqH7Q4Ac/ZB//7XHrpgfAYUPBxWBerBem6Q/Kk=";
  };

  # Ladybird's AK/kmalloc.cpp calls mimalloc's `mi_heap_get_default()`, which was
  # removed/renamed (to `mi_theap_get_default()`) in mimalloc 3.x. Ladybird pins
  # mimalloc 2.2.7 via vcpkg.json, so build against the matching 2.x series rather
  # than the nixpkgs default (3.x). Remove once Ladybird supports mimalloc 3.x.
  mimalloc2 = mimalloc.overrideAttrs {
    version = "2.2.7";
    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "mimalloc";
      tag = "v2.2.7";
      hash = "sha256-z9qMOTcGkURblZChXDGfQ58hrql52lG6EE1NQmxxuj0=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "0-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "LadybirdBrowser";
    repo = "ladybird";
    rev = "fa395b0e3d051ac6ad3d73911bd35766233eb151";
    hash = "sha256-9mQ5YRpME2azqIHjqtdlHcusU+o7oCZ+LfvRGipRS/k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-HI2GQEOkI25h1uYLIlMGb1wedDQ3mH+o7m1I9AM4LvA=";
  };

  patches = [
    # The LibSandbox seccomp policy applied to RequestServer omits readv/writev,
    # so curl/OpenSSL crash the process with SIGSYS on most HTTPS sites. Unfixed
    # upstream; Ladybird no longer accepts external patches. See patch header.
    ./allow-readv-writev-in-seccomp-sandbox.patch
  ];

  postPatch = ''
    sed -i '/iconutil/d' UI/CMakeLists.txt

    perl -0pi -e \
      's/find_package\(ICU 78\.[0-9]+ EXACT REQUIRED COMPONENTS data i18n uc\)/find_package(ICU ${icu78.version} EXACT REQUIRED COMPONENTS data i18n uc)/ or die "ICU dependency not found\n"' \
      Meta/CMake/check_for_dependencies.cmake

    # Don't set absolute paths in RPATH
    substituteInPlace Meta/CMake/lagom_install_options.cmake \
      --replace-fail "\''${CMAKE_INSTALL_BINDIR}" "bin" \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}" "lib"

    # The vendored wuffs 0.3.4 header trips Ladybird's -Werror (suggest-override,
    # calloc-transposed-args) when added as a normal include dir. vcpkg exposes it
    # as a system include; mirror that by marking WUFFS_INCLUDE_DIR SYSTEM.
    substituteInPlace Libraries/LibImageDecoders/CMakeLists.txt \
      --replace-fail \
        "target_include_directories(LibImageDecoders PRIVATE \''${WUFFS_INCLUDE_DIR})" \
        "target_include_directories(LibImageDecoders SYSTEM PRIVATE \''${WUFFS_INCLUDE_DIR})"
  '';

  preConfigure = ''
    # Setup caches for LibUnicode, LibTLS and LibGfx
    # Note that the versions of the input data packages must match the
    # expected version in the package's CMake.

    mkdir -p build/Caches

    cp -r ${unicode-character-database}/share/unicode build/Caches/UCD
    chmod +w build/Caches/UCD
    cp ${unicode-emoji}/share/unicode/emoji/emoji-test.txt build/Caches/UCD
    cp ${unicode-idna}/share/unicode/idna/IdnaMappingTable.txt build/Caches/UCD
    echo -n ${unicode-character-database.version} > build/Caches/UCD/version.txt
    chmod -w build/Caches/UCD

    mkdir build/Caches/PublicSuffix
    cp ${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat build/Caches/PublicSuffix

    mkdir build/Caches/HSTSPreload
    cp ${chromium-hsts-preload-list}/share/chromium-hsts-preload-list/transport_security_state_static.json build/Caches/HSTSPreload

    # Provide the pinned wuffs 0.3.4 single-file header on the include path.
    mkdir -p wuffs-include/wuffs
    cp ${wuffsHeader}/release/c/wuffs-v0.3.c wuffs-include/wuffs/wuffs-v0.3.c
    cmakeFlagsArray+=("-DWUFFS_INCLUDE_DIR=$PWD/wuffs-include")
  '';

  nativeBuildInputs = [
    cargo
    cmake
    makeWrapper
    ninja
    perl
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    qt6Packages.wrapQtAppsHook
    libtommath
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # glslangValidator is used to build the Vulkan DMABUF image shaders.
    glslang
  ];

  buildInputs = [
    curlFull
    fast-float
    ffmpeg
    fmt
    fontconfig
    libavif
    angle # libEGL
    libjxl
    libedit
    libwebp
    libxcrypt
    mimalloc2
    openssl
    qt6Packages.qtbase
    qt6Packages.qtmultimedia
    sdl3
    simdutf
    (skia.overrideAttrs (prev: {
      gnFlags = prev.gnFlags ++ [
        # https://github.com/LadybirdBrowser/ladybird/commit/af3d46dc06829dad65309306be5ea6fbc6a587ec
        # https://github.com/LadybirdBrowser/ladybird/commit/4d7b7178f9d50fff97101ea18277ebc9b60e2c7c
        # Remove when/if this gets upstreamed in skia.
        "extra_cflags+=[\"-DSKCMS_API=[[gnu::visibility(\\\"default\\\")]]\"]"
      ];
    }))
    woff2
    icu78
    simdjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio.dev
    qt6Packages.qtwayland
    # Vulkan GPU painting; on Linux this also enables shareable DMABUF images,
    # for which CMake now requires VulkanMemoryAllocator (and glslangValidator).
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
  ];

  cmakeFlags = [
    # Takes an enormous amount of resources, even with mold
    (lib.cmakeBool "ENABLE_LTO_FOR_RELEASE" false)
    # Disable network operations
    "-DLADYBIRD_CACHE_DIR=Caches"
    "-DENABLE_NETWORK_DOWNLOADS=OFF"
    # Ladybird requires icu 78, but without this flag the default icu
    # from other dependencies gets picked up instead.
    (lib.cmakeFeature "ICU_ROOT" (toString icu78.dev))
    # WUFFS_INCLUDE_DIR is set from preConfigure via cmakeFlagsArray so it can
    # point at the absolute path of the vendored wuffs 0.3.4 header directory.
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
  ];

  # FIXME: Add an option to -DENABLE_QT=ON on macOS to use Qt rather than Cocoa for the GUI

  # ld: [...]/OESVertexArrayObject.cpp.o: undefined reference to symbol 'glIsVertexArrayOES'
  # ld: [...]/libGL.so.1: error adding symbols: DSO missing from command line
  # https://github.com/LadybirdBrowser/ladybird/issues/371#issuecomment-2616415434
  env.NIX_LDFLAGS = "-lGL -lfontconfig";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/bundle/Ladybird.app $out/Applications
  '';

  # Only Ladybird and WebContent need wrapped, if Qt is enabled.
  # On linux we end up wraping some non-Qt apps, like headless-browser.
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  # Remove once upstream reads the trust store before sandboxing
  # (https://github.com/LadybirdBrowser/ladybird/pull/10256).
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram "$out/bin/Ladybird" \
        --add-flags "--certificate=${cacert}/etc/ssl/certs/ca-bundle.crt"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapProgram "$out/Applications/Ladybird.app/Contents/MacOS/Ladybird" \
        --add-flags "--certificate=${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';

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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
