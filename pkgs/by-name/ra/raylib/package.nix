{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  autoPatchelfHook,
  glfw,
  SDL2,
  alsa-lib,
  libpulseaudio,
  raylib-games,
  libGLU,
  libx11,
  platform ? "Desktop", # Note that "Web", "Android" and "Raspberry Pi" do not currently work
  pulseSupport ? stdenv.hostPlatform.isLinux,
  alsaSupport ? false,
  sharedLib ? true,
  includeEverything ? true,
}:
let
  inherit (lib) optional;

in

lib.checkListOfEnum "raylib: platform"
  [
    "Desktop"
    "Web"
    "Android"
    "Raspberry Pi"
    "SDL"
  ]
  [ platform ]
  (
    stdenv.mkDerivation (finalAttrs: {
      __structuredAttrs = true;

      pname = "raylib";
      version = "5.5-unstable-2026-01-20";

      src = fetchFromGitHub {
        owner = "raysan5";
        repo = "raylib";
        rev = "c610d228a244f930ad53492604640f39584c66da";
        hash = "sha256-7Lhgqb7QJwz94M1ZxWgueTwIgSVclGCvHklZXGzoJgQ=";
      };

      # autoPatchelfHook is needed for appendRunpaths
      nativeBuildInputs = [
        cmake
      ]
      ++ optional (builtins.length finalAttrs.appendRunpaths > 0) autoPatchelfHook;

      buildInputs = optional (platform == "Desktop") glfw ++ optional (platform == "SDL") SDL2;

      propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
        libGLU
        libx11
      ];

      # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
      cmakeFlags = [
        "-DCUSTOMIZE_BUILD=ON"
        "-DPLATFORM=${platform}"
      ]
      ++ optional (platform == "Desktop") "-DUSE_EXTERNAL_GLFW=ON"
      ++ optional includeEverything "-DINCLUDE_EVERYTHING=ON"
      ++ optional sharedLib "-DBUILD_SHARED_LIBS=ON";

      appendRunpaths = optional stdenv.hostPlatform.isLinux (
        lib.makeLibraryPath (optional alsaSupport alsa-lib ++ optional pulseSupport libpulseaudio)
      );

      passthru.tests = {
        inherit raylib-games;
      };

      meta = {
        description = "Simple and easy-to-use library to enjoy videogames programming";
        homepage = "https://www.raylib.com/";
        downloadPage = "https://github.com/raysan5/raylib";
        license = lib.licenses.zlib;
        maintainers = [ lib.maintainers.diniamo ];
        teams = [ lib.teams.ngi ];
        platforms = lib.platforms.all;
        changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.src.rev}/CHANGELOG";
      };
    })
  )
