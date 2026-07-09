{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  unicode-emoji,
  unicode-character-database,
  unicode-idna,
  publicsuffix-list,
  chromium-hsts-preload-list,
  cmake,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "LadybirdBrowser";
    repo = "ladybird";
    rev = "02b205361dd239e134f434e484b609d1fa5f1938";
    hash = "sha256-+CVJjrL1kqT2A7r89F+riiHpMa39rcggqG9SByidUY4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-n0ACVH8NXwe7SIaGFoJ20WIGGR3XjcuLTwPSKGJpT5s=";
  };

  postPatch = ''
    sed -i '/iconutil/d' UI/CMakeLists.txt

    perl -0pi -e \
      's/find_package\(ICU 78\.[0-9]+ EXACT REQUIRED COMPONENTS data i18n uc\)/find_package(ICU ${icu78.version} EXACT REQUIRED COMPONENTS data i18n uc)/ or die "ICU dependency not found\n"' \
      Meta/CMake/check_for_dependencies.cmake

    # Don't set absolute paths in RPATH
    substituteInPlace Meta/CMake/lagom_install_options.cmake \
      --replace-fail "\''${CMAKE_INSTALL_BINDIR}" "bin" \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}" "lib"
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
  '';

  nativeBuildInputs = [
    cargo
    cmake
    ninja
    perl
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    rustc
    qt6Packages.wrapQtAppsHook
    libtommath
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
    mimalloc
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
      # Ladybird depends on the vcpkg-packaged version of skia,
      # which includes this patch that exposes deprecated interfaces.
      patches = prev.patches or [ ] ++ [
        (fetchpatch {
          url = "https://github.com/microsoft/vcpkg/raw/64e1fbee7d9f40eab5d112aaff648c4dcffe9e47/ports/skia/skpath-enable-edit-methods.patch";
          hash = "sha256-r5+HqSjACINn8igXqBANQsq0K+fn+Ut8L2VRs40FkTM=";
        })
      ];
    }))
    woff2
    icu78
    simdjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio.dev
    qt6Packages.qtwayland
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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "Ladybird";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
