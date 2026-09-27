{
  lib,
  SDL,
  fetchFromGitHub,
  freetype,
  stdenv,
  unstableGitUpdater,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_ttf";
  version = "2.0.11-unstable-2026-07-05";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_ttf";
    rev = "3af6dd26174bb719c241447d1ea55e40597bb9a6";
    hash = "sha256-OLPsLIddOnKpMjW+P9D1gEKyYC125X6sqpBbm44d8d8=";
  };

  buildInputs = [
    SDL
    freetype
  ];

  # pass in correct *-config for cross builds
  env.SDL_CONFIG = lib.getExe' (lib.getDev SDL) "sdl-config";
  env.FT2_CONFIG = lib.getExe' freetype.dev "freetype-config";

  configureFlags = [
    (lib.enableFeature enableSdltest "sdltest")
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  strictDeps = true;

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "release-2.0.11";
    tagPrefix = "release-";
    branch = "SDL-1.2";
  };

  meta = {
    homepage = "https://github.com/libsdl-org/SDL_ttf";
    description = "SDL TrueType library";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    inherit (SDL.meta) platforms;
    knownVulnerabilities = [
      # CVE applies to SDL2 https://github.com/NixOS/nixpkgs/pull/274836#issuecomment-2708627901
      # "CVE-2022-27470"
    ];
  };
})
