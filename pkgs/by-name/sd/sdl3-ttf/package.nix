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
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_ttf";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-g7LfLxs7yr7bezQWPWn8arNuPxCfYLCO4kzXmLRUUSY=";
  };

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
