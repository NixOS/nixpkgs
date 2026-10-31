{
  lib,
  SDL,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  unstableGitUpdater,
  testers,
  # Boolean flags
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_net";
  version = "1.2.8-unstable-2026-05-27";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_net";
    rev = "8363cd02baf1b65c287691bdd22c3dc87da9759d";
    hash = "sha256-sAZ9I7jOo33Btitcl8mn4R7fYn2W8GWPttXELeEq7h4=";
  };

  nativeBuildInputs = [
    SDL
    pkg-config
  ];

  propagatedBuildInputs = [
    SDL
  ];

  configureFlags = [
    (lib.enableFeature enableSdltest "sdltest")
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
    homepage = "https://github.com/libsdl-org/SDL_net";
    description = "SDL networking library";
    license = lib.licenses.zlib;
    teams = [ lib.teams.sdl ];
    inherit (SDL.meta) platforms;
    pkgConfigModules = [ "SDL_net" ];
    identifiers.cpeParts =
      let
        # version shenanigans to strip -unstable suffix which is not supported by CPE
        versionString = "${lib.versions.majorMinor finalAttrs.version}.${lib.versions.patch finalAttrs.version}";
      in
      lib.meta.cpeFullVersionWithVendor "libsdl" versionString;
  };
})
