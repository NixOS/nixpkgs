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
  testSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl2-compat";
  version = "2.30.52";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl2-compat";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-pdY+yrLWIjMTjmKdYvX4DjzXy2cKaw6P90BPu8K163k";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    sdl3
  ];

  outputs = [
    "out"
    "dev"
  ];

  outputBin = "dev";

  cmakeFlags = [
    (lib.cmakeBool "SDL2COMPAT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = testSupport && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postFixup =
    if stdenv.hostPlatform.isDarwin then
      ''
        install_name_tool -add_rpath ${lib.makeLibraryPath [ sdl3 ]} $out/lib/libSDL2.dylib
      ''
    else
      ''
        patchelf --add-rpath ${lib.makeLibraryPath [ sdl3 ]} $out/lib/libSDL2.so
      '';

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
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "sdl2_compat" ];
  };
})
