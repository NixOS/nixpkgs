{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  testers,
  validatePkgConfig,
  sdl3,
  cmake,
  freetype,
  harfbuzz,
  glib,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-ttf";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_ttf";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-eq7yWw7PWIeXWjuNHaQUiV+x0qng4FJNscsYRALK40I=";
  };

  # fix CMake path handling (remove on next update)
  patches = [
    (fetchpatch {
      url = "https://github.com/libsdl-org/SDL_ttf/commit/ad2ffa825d4535ddfb57861a7e33dff4a9bc6a94.patch?full_index=1";
      hash = "sha256-emf7UnfB6Rl1+R74lsoIvm9ezDZtjHUS/t4k/RxbaYg=";
    })
  ];

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    cmake
    ninja
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    freetype
    harfbuzz
    glib
  ];

  cmakeFlags = [
    (lib.cmakeBool "SDLTTF_STRICT" true)
    (lib.cmakeBool "SDLTTF_HARFBUZZ" true)
    # disable plutosvg (not in nixpkgs)
    (lib.cmakeBool "SDLTTF_PLUTOSVG" false)
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "SDL TrueType font library";
    homepage = "https://github.com/libsdl-org/SDL_ttf";
    changelog = "https://github.com/libsdl-org/SDL_ttf/releases/tag/${toString finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      charain
      Emin017
    ];
    pkgConfigModules = [ "sdl3-ttf" ];
    platforms = lib.platforms.all;
  };
})
