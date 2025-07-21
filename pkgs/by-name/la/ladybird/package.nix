{
  lib,
  stdenv,
  fetchFromGitHub,
  cacert,
  unicode-emoji,
  unicode-character-database,
  unicode-idna,
  publicsuffix-list,
  cmake,
  copyDesktopItems,
  makeDesktopItem,
  ninja,
  pkg-config,
  curl,
  libavif,
  libGL,
  libjxl,
  libpulseaudio,
  libwebp,
  libxcrypt,
  openssl,
  python3,
  qt6Packages,
  woff2,
  ffmpeg,
  fontconfig,
  simdutf,
  skia,
  nixosTests,
  unstableGitUpdater,
  apple-sdk_14,
  libtommath,
}:

let
  # Note: The cacert version is synthetic and must match the version in the package's CMake
  cacert_version = "2025-05-20";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "LadybirdWebBrowser";
    repo = "ladybird";
    rev = "831ba5d6550fd9dfaf90153876ff42396f7165ac";
    hash = "sha256-7feXPFKExjuOGbitlAkSEEzYNEZb6hGSDUZW1EJGIW8=";
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

    # Check that the versions match
    grep -F 'set(CACERT_VERSION "${cacert_version}")' Meta/CMake/ca_certificates_data.cmake || (echo cacert_version mismatch && exit 1)

    mkdir -p build/Caches

    cp -r ${unicode-character-database}/share/unicode build/Caches/UCD
    chmod +w build/Caches/UCD
    cp ${unicode-emoji}/share/unicode/emoji/emoji-test.txt build/Caches/UCD
    cp ${unicode-idna}/share/unicode/idna/IdnaMappingTable.txt build/Caches/UCD
    echo -n ${unicode-character-database.version} > build/Caches/UCD/version.txt
    chmod -w build/Caches/UCD

    mkdir build/Caches/CACERT
    cp ${cacert}/etc/ssl/certs/ca-bundle.crt build/Caches/CACERT/cacert-${cacert_version}.pem
    echo -n ${cacert_version} > build/Caches/CACERT/version.txt

    mkdir build/Caches/PublicSuffix
    cp ${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat build/Caches/PublicSuffix
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    python3
    qt6Packages.wrapQtAppsHook
    libtommath
  ];

  buildInputs =
    [
      curl
      ffmpeg
      fontconfig
      libavif
      libGL
      libjxl
      libwebp
      libxcrypt
      openssl
      qt6Packages.qtbase
      qt6Packages.qtmultimedia
      simdutf
      (skia.overrideAttrs (prev: {
        gnFlags = prev.gnFlags ++ [
          # https://github.com/LadybirdBrowser/ladybird/commit/af3d46dc06829dad65309306be5ea6fbc6a587ec
          # https://github.com/LadybirdBrowser/ladybird/commit/4d7b7178f9d50fff97101ea18277ebc9b60e2c7c
          # Remove when/if this gets upstreamed in skia.
          "extra_cflags+=[\"-DSKCMS_API=__attribute__((visibility(\\\"default\\\")))\"]"
        ];
      }))
      woff2
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux [
      libpulseaudio.dev
      qt6Packages.qtwayland
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
    ];

  cmakeFlags =
    [
      # Takes an enormous amount of resources, even with mold
      (lib.cmakeBool "ENABLE_LTO_FOR_RELEASE" false)
      # Disable network operations
      "-DSERENITY_CACHE_DIR=Caches"
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

  postInstall =
    ''
      for size in 48x48 128x128; do
        mkdir -p $out/share/icons/hicolor/$size/apps
        ln -s $out/share/Lagom/icons/$size/app-browser.png \
          $out/share/icons/hicolor/$size/apps/ladybird.png
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications $out/bin
      mv $out/bundle/Ladybird.app $out/Applications
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "ladybird";
      desktopName = "Ladybird";
      exec = "Ladybird -- %U";
      icon = "ladybird";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      actions.new-window = {
        name = "New Window";
        exec = "Ladybird --new-window -- %U";
      };
    })
  ];

  # Only Ladybird and WebContent need wrapped, if Qt is enabled.
  # On linux we end up wraping some non-Qt apps, like headless-browser.
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Browser using the SerenityOS LibWeb engine with a Qt or Cocoa GUI";
    homepage = "https://ladybird.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
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
