{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchsvn,
  cmake,
  pkg-config,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  SDL2,
  glew,
  openal,
  libvorbis,
  libogg,
  curl,
  freetype,
  libjpeg,
  libpng,
  libx11,
  harfbuzz,
  mcpp,
  wiiuse,
  angelscript,
  libopenglrecorder,
  sqlite,
  libsamplerate,
  libsquish,
  shaderc,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "supertuxkart";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "supertuxkart";
    repo = "stk-code";
    tag = finalAttrs.version;
    hash = "sha256-/fp5iqTHVrVcxRqbTy/3r+dp19oUj9MI2JauvtPWTWA=";
  };

  postPatch = ''
    # Deletes all bundled libs in stk-code/lib except those
    # That couldn't be replaced with system packages
    find lib -maxdepth 1 -type d | egrep -v "^lib$|${(lib.concatStringsSep "|" bundledLibraries)}" | xargs -n1 -L1 -r -I{} rm -rf {}

    # Allow building with system-installed wiiuse on Darwin
    substituteInPlace CMakeLists.txt \
      --replace 'NOT (APPLE OR HAIKU)) AND USE_SYSTEM_WIIUSE' 'NOT (HAIKU)) AND USE_SYSTEM_WIIUSE'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
    shaderc
    SDL2
    glew
    libvorbis
    libogg
    freetype
    curl
    libjpeg
    libpng
    harfbuzz
    mcpp
    wiiuse
    angelscript
    sqlite
    libsquish
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libx11
  ++ lib.optional (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isLinux) libopenglrecorder
  ++ lib.optional stdenv.hostPlatform.isLinux openal
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libsamplerate
  ];

  cmakeFlags = [
    "-DBUILD_RECORDER=${
      if (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isLinux) then "ON" else "OFF"
    }"
    "-DUSE_SYSTEM_ANGELSCRIPT=ON"
    "-DCHECK_ASSETS=OFF"
    "-DUSE_SYSTEM_WIIUSE=ON"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  env.CXXFLAGS = toString [
    # GCC 13: error: 'snprintf' was not declared in this scope
    "-include cstdio"
    # GCC 13: error: 'runtime_error' is not a member of 'std'
    "-include stdexcept"
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/bin $out/Applications
      mv $out/supertuxkart.app $out/Applications/SuperTuxKart.app
      cp $out/Applications/SuperTuxKart.app/Contents/MacOS/supertuxkart \
        $out/bin/supertuxkart
      ln -sfn $out/share/supertuxkart/data \
        $out/Applications/SuperTuxKart.app/Contents/Resources/data
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      for res in 16 32 48 64 128 256 512 1024; do
        install -Dm644 data/supertuxkart_''${res}.png \
          $out/share/icons/hicolor/''${res}x''${res}/apps/supertuxkart.png
      done
    '';

  # Obtain the assets directly from the fetched store path, to avoid duplicating assets across multiple engine builds.
  # On Darwin, also patch the copy inside the app bundle so launching via Finder works.
  preFixup = ''
    wrapProgram $out/bin/supertuxkart \
      --set-default SUPERTUXKART_ASSETS_DIR "${assets}" \
      --set-default SUPERTUXKART_DATADIR "$out/share/supertuxkart"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp $out/bin/supertuxkart \
      $out/Applications/SuperTuxKart.app/Contents/MacOS/supertuxkart
  '';

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
    name = "supertuxkart";
    exec = "supertuxkart";
    icon = "supertuxkart";
    desktopName = "SuperTuxKart";
    comment = "3D open-source arcade racer";
    genericName = "Arcade Racer";
    categories = [
      "Game"
      "ArcadeGame"
    ];
    keywords = [
      "tux"
      "kart"
      "race"
    ];
  });

  passthru = {
    assets = fetchsvn {
      url = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
      rev = "18621";
      sha256 = "sha256-iqQSezGu0tecA53qhrtYA77SLj28WUUCcL4ZCJbK5C8=";
      name = "stk-assets";
    };

    # List of bundled libraries in stk-code/lib to keep
    # Those are the libraries that cannot be replaced
    # with system packages.
    bundledLibraries = [
      # Bullet 2.87 is incompatible (bullet 2.79 needed whereas 2.87 is packaged)
      # The api changed in a lot of classes, too much work to adapt
      "bullet"

      # Upstream Libenet doesn't yet support IPv6,
      # So we will use the bundled libenet which
      # has been fixed to support it.
      "enet"

      # Internal library of STK, nothing to do about it
      "graphics_engine"

      # Internal library of STK, nothing to do about it
      "graphics_utils"

      # Internal library.
      "simd_wrapper"

      # This irrlicht is bundled with cmake
      # whereas upstream irrlicht still uses
      # archaic Makefiles, too complicated to switch to.
      "irrlicht"

      # No USE_SYSTEM_SHEENBIDI flag upstream
      "sheenbidi"

      # No USE_SYSTEM_TINYGETTEXT flag upstream
      "tinygettext"

      # Used on Darwin as a static OpenAL replacement (USE_MOJOAL=ON by default on Apple)
      "mojoal"
    ];
  };

  meta = {
    description = "3D open-source arcade racer";
    mainProgram = "supertuxkart";
    longDescription = ''
      Karts. Nitro. Action! SuperTuxKart is a 3D open-source arcade racer
      with a variety of characters, tracks, and modes to play.
      It aims to be more fun than realistic, and provides an enjoyable experience for all ages.
    '';
    homepage = "https://supertuxkart.net/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      philocalyst
      SchweGELBin
    ];
    platforms = with lib.platforms; unix;
    changelog = "https://github.com/supertuxkart/stk-code/blob/${finalAttrs.version}/CHANGELOG.md";
  };
})
