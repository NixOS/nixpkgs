{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  desktopToDarwinBundle,
  libGL,
  libGLU,
  nix-update-script,
  pkg-config,
  SDL_gfx,
  SDL_image,
  SDL_mixer,
  sdl12-compat,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openxcom";
  version = "1.0-unstable-2026-09-28";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "4a4bae5fa2e5a09282928e84943fc84b093e34ff";
    hash = "sha256-hgW0n1BzzQe0guXJWF9KlDcpWz1JpFFJ6IGPP1nZgTA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  # The terminal font is blitted onto a surface with only 2 palette entries set.
  # SDL 1.2 left the rest black, but sdl12-compat inherits SDL2's all-white
  # default, so the glyphs map to an index the screen never gets a color for
  # and the startup/error screen renders black on black.
  postPatch = ''
    substituteInPlace src/Engine/Font.cpp \
      --replace-fail \
        'image.surface = new Surface(s->w, s->h);' \
        'image.surface = new Surface(s->w, s->h); { SDL_Color black[256] = {}; image.surface->setPalette(black, 0, 256); }'

    # The window icon is looked up before the file map is built, so it is never
    # found; search the data folders directly instead
    substituteInPlace src/Engine/Game.cpp \
      --replace-fail 'FileMap::getFilePath("openxcom.png")' 'CrossPlatform::searchDataFile("common/openxcom.png")'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Don't replace the Dock icon with the raw window icon, so macOS keeps
    # showing the app bundle's icon, styled like other apps
    substituteInPlace src/Engine/CrossPlatform.cpp \
      --replace-fail 'SDL_WM_SetIcon(icon, NULL);' ""
  '';

  buildInputs = [
    SDL_gfx
    SDL_image
    SDL_mixer
    sdl12-compat
    yaml-cpp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libGLU
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ (lib.cmakeBool "CREATE_BUNDLE" false) ];

  # desktopToDarwinBundle only scales up the 128x128 PNG, use upstream's icon
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp ${finalAttrs.src}/res/mac/AppIcon.icns "$out/Applications/OpenXcom.app/Contents/Resources/openxcom.icns"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Open source clone of UFO: Enemy Unknown and X-COM: Terror From the Deep (legacy version)";
    longDescription = ''
      OpenXcom is an open source clone of UFO: Enemy Unknown (X-COM: UFO
      Defense) and X-COM: Terror From the Deep. It requires the data files
      from either or both of the original games.

      OpenXcom is kept as a legacy version which only receives bugfixes. Its
      developers recommend OpenXcom Extended instead, see openxcom-extended.
    '';
    homepage = "https://openxcom.org";
    downloadPage = "https://openxcom.org/download/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      keenanweaver
      iedame
    ];
    mainProgram = "openxcom";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
