{
  SDL2_image,
  stdenv,
  SDL2_ttf,
  SDL2_net,
  fpc,
  haskell,
  ffmpeg,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  lua5_1,
  SDL2,
  SDL2_mixer,
  zlib,
  libpng,
  libGL,
  libGLU,
  libglut,
  physfs,
  qt5,
  hicolor-icon-theme,
  withServer ? !stdenv.isDarwin,
}:

let
  inherit (qt5) qtbase qttools wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hedgewars";
  version = "1.0.3";

  # Fetchg is disabled due to adversarial auth conditions
  src = fetchurl {
    url = "https://hedgewars.org/download/releases/hedgewars-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xcGHfAuuE1THXSuVJ7b5qfeemZMuXQix9vfeFwgGYTA=";
  };

  patches = lib.optionals stdenv.isDarwin [
    ./cmake-darwin-arm64.patch
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-deprecated-declarations -Wno-format-security";

  postPatch = ''
    # cmake >= 3.20 rejects get_target_property with LOCATION.
    substituteInPlace misc/liblua/CMakeLists.txt \
      --replace-fail 'get_target_property(lua_fullpath lua LOCATION)' \
                     'set(lua_fullpath "$<TARGET_FILE:lua>")'
  ''
  + lib.optionalString stdenv.isDarwin ''
    # Anchor the bundle prefix to the Nix store path so cmake installs into
    # $out/Hedgewars.app/... rather than a bare relative path outside the store.
    substituteInPlace cmake_modules/paths.cmake \
      --replace-fail \
        'set(CMAKE_INSTALL_PREFIX "Hedgewars.app/Contents/MacOS/")' \
        'set(CMAKE_INSTALL_PREFIX "''${CMAKE_INSTALL_PREFIX}/Hedgewars.app/Contents/MacOS/")'

    # hedgewars passes the full physfs dylib path to -Fl but should pass the dir.
    substituteInPlace hedgewars/CMakeLists.txt \
      --replace-fail \
        'add_flag_append(CMAKE_Pascal_FLAGS "-Fl''${PHYSFS_LIBRARY}")' \
        'add_flag_append(CMAKE_Pascal_FLAGS "-Fl''${PHYSFS_LIBRARY_DIR}")'

    # Apple SDK 14+ no longer ships libz.tbd, so FPC cannot find it via the
    # baked-in SDK path.
    substituteInPlace hedgewars/CMakeLists.txt \
      --replace-fail \
        'add_flag_append(CMAKE_Pascal_FLAGS "-k-L''${PNG_LIBRARY_DIR} -Fl''${PNG_LIBRARY_DIR}")' \
        'add_flag_append(CMAKE_Pascal_FLAGS "-k-L''${PNG_LIBRARY_DIR} -Fl''${PNG_LIBRARY_DIR} -Fl${zlib.out}/lib")'

    # SDLInteraction.h explicitly undefs and resets MAC_OS_X_VERSION_MIN_REQUIRED
    # to MAC_OS_X_VERSION_10_6 (= 1060) just before including SDL_mixer.h.
    substituteInPlace QTfrontend/util/SDLInteraction.h \
      --replace-fail 'MAC_OS_X_VERSION_10_6' 'MAC_OS_X_VERSION_10_7'

  '';

  preConfigure = lib.optionalString stdenv.isDarwin ''
    # Reset to 10.13 so the Nix clang wrapper emits -mmacos-version-min=10.13
    # rather than the nixpkgs apple-sdk default of 14.0, which would make
    # MAC_OS_X_VERSION_MIN_REQUIRED resolve below the value sdl2-compat requires.
    export MACOSX_DEPLOYMENT_TARGET=10.13
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2_ttf
    SDL2_net
    SDL2
    SDL2_mixer
    SDL2_image
    fpc
    lua5_1
    ffmpeg
    physfs
    qtbase
    hicolor-icon-theme
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    libGL
    libGLU
    libglut
  ]
  ++ lib.optionals withServer [
    (haskell.packages.ghc948.ghcWithPackages (
      hpkgs: with hpkgs; [
        SHA
        aeson
        bytestring
        entropy
        hslogger
        mtl
        network
        network-bsd
        random
        regex-tdfa
        sandi
        text
        utf8-string
        vector
        yaml
        zlib
      ]
    ))
  ];

  cmakeFlags = [
    (lib.cmakeBool "NOVERSIONINFOUPDATE" true)
    (lib.cmakeBool "NOSERVER" (!withServer))
  ]
  ++ lib.optionals stdenv.isDarwin [
    # Prevents fixup_bundle from running (it needs OggVorbis and fails in sandbox).
    (lib.cmakeBool "SKIPBUNDLE" true)
    (lib.cmakeOptionType "STRING" "CMAKE_OSX_DEPLOYMENT_TARGET" "10.13")
    (lib.cmakeBool "NOAUTOUPDATE" true)
  ];

  # runtimeDependencies adds -rpath entries via cc-wrapper so the Qt frontend
  # and C helpers can find these libraries without LD_LIBRARY_PATH at runtime.
  runtimeDependencies = [
    SDL2.out
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    libpng.out
    lua5_1
    physfs
    zlib.out
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    libGL
    libGLU
  ];

  # Build system isn't well-behaved
  env.NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework Foundation -framework AppKit -lobjc";

  # wrapQtAppsHook would wrap every executable it finds, including dylibs in
  # Frameworks/, replacing them with shell scripts dyld cannot load.
  dontWrapQtApps = stdenv.isDarwin;

  qtWrapperArgs = lib.optionals (!stdenv.isDarwin) [
    "--prefix LD_LIBRARY_PATH:"
    (lib.makeLibraryPath [
      libGL
      libGLU
      libglut
      physfs
    ])
  ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    wrapQtApp "$out/Hedgewars.app/Contents/MacOS/hedgewars"
  '';

  postInstall =
    lib.optionalString (!stdenv.isDarwin) ''
      install -Dm644 "$out/share/hedgewars/Data/misc/hedgewars.desktop" \
        "$out/share/applications/hedgewars.desktop"

      substituteInPlace "$out/share/applications/hedgewars.desktop" \
        --replace-fail "Exec=hedgewars" "Exec=$out/bin/hedgewars"

      for size in 16 32 48 64 128 256 512; do
        install -Dm644 "$NIX_BUILD_TOP/$sourceRoot/misc/hedgewars.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/hedgewars.png"
      done

      install -Dm644 "$out/share/hedgewars.metainfo.xml" \
        "$out/share/metainfo/hedgewars.metainfo.xml"
    ''
    + lib.optionalString stdenv.isDarwin ''
      # Expose the bundle binary on PATH so that wrapQtAppsHook wraps it and
      # it is accessible without invoking the .app bundle directly.
      mkdir -p "$out/bin"
      ln -s "$out/Hedgewars.app/Contents/MacOS/hedgewars" "$out/bin/hedgewars"
    ''
    + ''
      install -Dm644 "$NIX_BUILD_TOP/$sourceRoot/Fonts_LICENSE.txt" \
        "$out/share/licenses/hedgewars/Fonts_LICENSE.txt"
    '';

  meta = {
    description = "Funny turn-based artillery game, featuring fighting hedgehogs";
    homepage = "https://hedgewars.org/";
    license = with lib.licenses; [
      gpl2Only
      fdl12Only
      bitstreamVera
      asl20
    ];
    longDescription = ''
      Each player controls a team of several hedgehogs. During the course of
      the game, players take turns with one of their hedgehogs. They then use
      whatever tools and weapons are available to attack and kill the
      opponents' hedgehogs, thereby winning the game. Hedgehogs may move
      around the terrain in a variety of ways, normally by walking and jumping
      but also by using particular tools such as the "Rope" or "Parachute", to
      move to otherwise inaccessible areas. Each turn is time-limited to
      ensure that players do not hold up the game with excessive thinking or
      moving.

      A large variety of tools and weapons are available for players during
      the game: Grenade, Cluster Bomb, Bazooka, UFO, Homing Bee, Shotgun,
      Desert Eagle, Fire Punch, Baseball Bat, Dynamite, Mine, Rope, Pneumatic
      pick, Parachute. Most weapons, when used, cause explosions that deform
      the terrain, removing circular chunks. The landscape is an island
      floating on a body of water, or a restricted cave with water at the
      bottom. A hedgehog dies when it enters the water (either by falling off
      the island, or through a hole in the bottom of it), it is thrown off
      either side of the arena or when its health is reduced, typically from
      contact with explosions, to zero (the damage dealt to the attacked
      hedgehog or hedgehogs after a player's or CPU turn is shown only after
      all movement on the battlefield has ceased).
    '';
    maintainers = with lib.maintainers; [
      kragniz
      fpletz
      philocalyst
    ];
    platforms = lib.platforms.all;
  };
})
