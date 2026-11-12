{
  lib,
  SDL,
  fetchFromGitHub,
  giflib,
  libxpm,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  stdenv,
  unstableGitUpdater,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_image";
  version = "1.2.12-unstable-2026-07-05";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    rev = "2ffb2e3e1eba037897164e3ac6c67570d8bccd79";
    hash = "sha256-fGwSb3GYfzcrWn7F70xhNxBXygYdD2uuzFQudS1lCqU=";
  };

  configureFlags = [
    # Disable dynamic loading or else dlopen will fail because of no proper
    # rpath
    (lib.enableFeature false "jpg-shared")
    (lib.enableFeature false "png-shared")
    (lib.enableFeature false "tif-shared")
    (lib.enableFeature false "webp-shared")
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
  ];

  nativeBuildInputs = [
    SDL
    pkg-config
  ];

  buildInputs = [
    SDL
    giflib
    libxpm
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    updateScript = unstableGitUpdater {
      tagFormat = "release-1.*";
      tagPrefix = "release-";
      branch = "SDL-1.2";
    };
  };

  meta = {
    homepage = "https://www.libsdl.org/projects/SDL_image/";
    description = "SDL image library";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    inherit (SDL.meta) platforms;
    pkgConfigModules = [ "SDL_image" ];
    identifiers.cpeParts =
      let
        # version shenanigans to strip -unstable suffix which is not supported by CPE
        versionString = "${lib.versions.majorMinor finalAttrs.version}.${lib.versions.patch finalAttrs.version}";
      in
      lib.meta.cpeFullVersionWithVendor "libsdl" versionString;
  };
})
