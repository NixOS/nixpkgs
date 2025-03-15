{
  cmake,
  lib,
  fetchFromGitHub,
  monado,
  ninja,
  nix-update-script,
  SDL2_ttf,
  SDL2_net,
  SDL2_gfx,
  SDL2_sound,
  SDL2_mixer,
  SDL2_image,
  sdl3,
  stdenv,
  testers,
  libX11,
  libGL,
  testSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl2-compat";
  version = "2.32.52";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl2-compat";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-adtFcBFclfub//KGpxqObuTIZbh9r4k/jdJEnP1Hzpw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    sdl3
    libX11
  ];

  checkInputs = [
    libGL
  ];

  outputs = [
    "out"
    "dev"
  ];

  outputBin = "dev";

  # SDL3 is dlopened at runtime, leave it in runpath
  dontPatchELF = true;

  cmakeFlags = [
    (lib.cmakeBool "SDL2COMPAT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_INSTALL_RPATH" (lib.makeLibraryPath [ sdl3 ]))
  ];

  # skip timing-based tests as those are flaky
  env.SDL_TESTS_QUICK = 1;

  doCheck = testSupport && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  patches = [ ./find-headers.patch ];
  setupHook = ./setup-hook.sh;

  passthru = {
    tests =
      let
        replaceSDL2 = drv: drv.override { SDL2 = finalAttrs.finalPackage; };
      in
      {
        pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
        SDL2_ttf = replaceSDL2 SDL2_ttf;
        SDL2_net = replaceSDL2 SDL2_net;
        SDL2_gfx = replaceSDL2 SDL2_gfx;
        SDL2_sound = replaceSDL2 SDL2_sound;
        SDL2_mixer = replaceSDL2 SDL2_mixer;
        SDL2_image = replaceSDL2 SDL2_image;
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        monado = replaceSDL2 monado;
      };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(.*)"
      ];
    };
  };

  meta = {
    description = "SDL2 compatibility layer that uses SDL3 behind the scenes";
    homepage = "https://libsdl.org";
    changelog = "https://github.com/libsdl-org/sdl2-compat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ nadiaholmquist ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "sdl2_compat" ];
  };
})
