{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libavif,
  libpng,
  libjpeg,
  libogg,
  libx11,
  flac,
  glew,
  openal,
  cmake,
  pkg-config,
  libmad,
  libuuid,
  minizip,
  libicns,
  apple-sdk_15,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "endless-sky";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QXLIHAAdpK6lvKv0471KsiB+B06RKUfYoUNYKi8NAlg=";
  };

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    ./fixes.patch
  ];

  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # the trailing slash is important!!
      # endless sky naively joins the paths with string concatenation
      # so it's essential that there be a trailing slash on the resources path
      substituteInPlace source/Files.cpp \
        --replace-fail '%NIXPKGS_RESOURCES_PATH%' "$out/share/games/endless-sky/"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # iconutil is a macOS SDK tool unavailable in the nix sandbox;
      # replace with png2icns from libicns for equivalent icns generation
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'iconutil -c icns -o icons/endless-sky.icns icons/endless-sky.iconset' \
          'png2icns icons/endless-sky.icns icons/endless-sky.iconset/icon_16x16.png icons/endless-sky.iconset/icon_32x32.png icons/endless-sky.iconset/icon_128x128.png icons/endless-sky.iconset/icon_256x256.png icons/endless-sky.iconset/icon_512x512.png'

      # cmake's find_path(UUID_INCLUDE uuid/uuid.h) resolves to
      # Kernel.framework/Headers and adds it with -I, shadowing libcxx's
      # stddef.h. uuid/uuid.h is already in usr/include/uuid/ via the SDK
      # sysroot, so no explicit include dir is needed.
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'target_include_directories(ExternalLibraries INTERFACE "''${UUID_INCLUDE}")' \
          ""
    '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
  ];

  buildInputs = [
    SDL2
    libavif
    libpng
    libjpeg
    libogg
    flac
    openal
    libmad
    minizip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    glew
    libuuid
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "ES_USE_VCPKG" false)
    (lib.cmakeBool "ES_CREATE_BUNDLE" true)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    mv "$out/Endless Sky.app" "$out/Applications/"
    ln -s "$out/Applications/Endless Sky.app/Contents/MacOS/Endless Sky" "$out/bin/endless-sky"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    longDescription = ''
      Endless Sky is a sandbox-style space exploration game. You start as the captain
      of a tiny spaceship and can choose what to do from there. The game includes a
      major plot line and many minor missions, but you can play as a merchant, bounty
      hunter, or explorer entirely at your own discretion. Trade goods between star
      systems, upgrade your ship, recruit a fleet, and uncover alien civilisations
      beyond the boundaries of human space.
    '';
    mainProgram = "endless-sky";
    homepage = "https://endless-sky.github.io/";
    changelog = "https://github.com/endless-sky/endless-sky/blob/v${finalAttrs.version}/changelog";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-30
      cc-by-sa-40
      publicDomain
    ];
    maintainers = with lib.maintainers; [
      _360ied
      lilacious
      philocalyst
    ];
    platforms = lib.platforms.all;
  };
})
