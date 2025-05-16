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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl2-compat";
  version = "2.32.56";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl2-compat";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-Xg886KX54vwGANIhTAFslzPw/sZs2SvpXzXUXcOKgMs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    sdl3
    libX11
  ];

  checkInputs = [ libGL ];

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

  doCheck = true;

  patches = [ ./find-headers.patch ];
  setupHook = ./setup-hook.sh;

  postFixup = ''
    # allow as a drop in replacement for SDL2
    # Can be removed after treewide switch from pkg-config to pkgconf
    ln -s $dev/lib/pkgconfig/sdl2-compat.pc $dev/lib/pkgconfig/sdl2.pc
  '';

  passthru = {
    tests =
      {
        pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

        inherit
          SDL2_ttf
          SDL2_net
          SDL2_gfx
          SDL2_sound
          SDL2_mixer
          SDL2_image
          ;
      }
      // lib.optionalAttrs stdenv.hostPlatform.isLinux {
        inherit monado;
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
    maintainers = with lib.maintainers; [
      nadiaholmquist
    ];
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "sdl2-compat"
      "sdl2"
    ];
  };
})
