{
  lib,
  stdenv,
  fetchFromGitHub,
  unicode-emoji,
  unicode-character-database,
  unicode-idna,
  publicsuffix-list,
  cmake,
  ninja,
  pkg-config,
  curl,
  libavif,
  angle, # libEGL
  libjxl,
  libpulseaudio,
  libwebp,
  libxcrypt,
  openssl,
  python3,
  qt6Packages,
  woff2,
  fast-float,
  ffmpeg,
  fontconfig,
  simdutf,
  skia,
  nixosTests,
  unstableGitUpdater,
  libtommath,
  sdl3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "LadybirdBrowser";
    repo = "ladybird";
    rev = "62c00712faa2cd923f18feb3c72a1348aef51145";
    hash = "sha256-0sJeSCW5OkhjnQL/vKwi63xOfg63cPFN/jAVrH0Bk/A=";
  };

  postPatch = ''
    sed -i '/iconutil/d' UI/CMakeLists.txt

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
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    qt6Packages.wrapQtAppsHook
    libtommath
  ];

  buildInputs = [
    curl
    fast-float
    ffmpeg
    fontconfig
    libavif
    angle # libEGL
    libjxl
    libwebp
    libxcrypt
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
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux [
    libpulseaudio.dev
    qt6Packages.qtwayland
  ];

  cmakeFlags = [
    # Takes an enormous amount of resources, even with mold
    (lib.cmakeBool "ENABLE_LTO_FOR_RELEASE" false)
    # Disable network operations
    "-DLADYBIRD_CACHE_DIR=Caches"
    "-DENABLE_NETWORK_DOWNLOADS=OFF"
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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Browser using the SerenityOS LibWeb engine with a Qt or Cocoa GUI";
    homepage = "https://ladybird.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      fgaz
      jk
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
