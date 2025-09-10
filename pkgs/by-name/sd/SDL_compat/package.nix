{
  lib,
  sdl2-compat,
  cmake,
  darwin,
  fetchFromGitHub,
  libGLU,
  libiconv,
  libX11,
  mesa,
  pkg-config,
  pkg-config-unwrapped,
  stdenv,
  testers,
  dosbox,
  SDL_image,
  SDL_ttf,
  SDL_mixer,
  SDL_sound,
  # Boolean flags
  libGLSupported ? lib.elem stdenv.hostPlatform.system mesa.meta.platforms,
  openglSupport ? libGLSupported,
}:

let
  inherit (darwin) autoSignDarwinBinariesHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_compat";
  version = "1.2.68";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl12-compat";
    rev = "release-" + finalAttrs.version;
    hash = "sha256-f2dl3L7/qoYNl4sjik1npcW/W09zsEumiV9jHuKnUmM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
  ];

  # re-export PKG_CHECK_MODULES m4 macro used by sdl.m4
  propagatedNativeBuildInputs = [ pkg-config-unwrapped ];

  buildInputs = [
    libX11
    sdl2-compat
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals openglSupport [ libGLU ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_SKIP_RPATH TRUE)' 'set(CMAKE_SKIP_RPATH FALSE)'
  '';

  dontPatchELF = true; # don't strip rpath

  cmakeFlags =
    let
      rpath = lib.makeLibraryPath [ sdl2-compat ];
    in
    [
      (lib.cmakeFeature "CMAKE_INSTALL_RPATH" rpath)
      (lib.cmakeFeature "CMAKE_BUILD_RPATH" rpath)
      (lib.cmakeBool "SDL12TESTS" finalAttrs.finalPackage.doCheck)
    ];

  enableParallelBuilding = true;

  # Darwin fails with "Critical error: required built-in appearance SystemAppearance not found"
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkPhase = ''
    runHook preCheck
    ./testver
    runHook postCheck
  '';

  postInstall = ''
    # allow as a drop in replacement for SDL
    # Can be removed after treewide switch from pkg-config to pkgconf
    ln -s $out/lib/pkgconfig/sdl12_compat.pc $out/lib/pkgconfig/sdl.pc
  '';

  # The setup hook scans paths of buildInputs to find SDL related packages and
  # adds their include and library paths to environment variables. The sdl-config
  # is patched to use these variables to produce correct flags for compiler.
  patches = [ ./find-headers.patch ];
  setupHook = ./setup-hook.sh;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

    inherit
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL_sound
      dosbox
      ;
  };

  meta = {
    homepage = "https://www.libsdl.org/";
    description = "Cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    license = lib.licenses.zlib;
    mainProgram = "sdl-config";
    maintainers = with lib.maintainers; [ peterhoeg ];
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "sdl"
      "sdl12_compat"
    ];
  };
})
