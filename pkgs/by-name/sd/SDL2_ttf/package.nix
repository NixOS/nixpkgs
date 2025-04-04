{
  lib,
  SDL2,
  darwin,
  fetchurl,
  freetype,
  harfbuzz,
  libGL,
  pkg-config,
  stdenv,
  testers,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_ttf";
  version = "2.24.0";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${finalAttrs.version}.tar.gz";
    hash = "sha256-Cyvx57ZWitvbybuSRkP3nZ3tr+Bh+h7Wh9HZrE5FO/0=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs =
    [
      SDL2
      freetype
      harfbuzz
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libGL
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libobjc
    ];

  configureFlags = [
    (lib.enableFeature false "harfbuzz-builtin")
    (lib.enableFeature false "freetype-builtin")
    (lib.enableFeature enableSdltest "sdltest")
  ];

  strictDeps = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_ttf";
    description = "Support for TrueType (.ttf) font files with Simple Directmedia Layer";
    license = lib.licenses.zlib;
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    inherit (SDL2.meta) platforms;
    pkgConfigModules = [ "SDL2_ttf" ];
  };
})
