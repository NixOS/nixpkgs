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
  libxrandr,
  platform ? "Desktop", # Note that "Web", "Android" and "Raspberry Pi" do not currently work
  pulseSupport ? stdenv.hostPlatform.isLinux,
  alsaSupport ? false,
  sharedLib ? true,
  includeEverything ? true,
  customFrameControlSupport ? false,
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
      version = "6.0";

      src = fetchFromGitHub {
        owner = "raysan5";
        repo = "raylib";
        rev = finalAttrs.version;
        hash = "sha256-8+6MDTMc7Spix4ndAUzp51Q5iWcl7pQmyXuV2RutnOk=";
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
        libxrandr
      ];

      # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
      cmakeFlags = [
        (lib.cmakeBool "CUSTOMIZE_BUILD" true)
        # The above also enables `SUPPORT_CUSTOM_FRAME_CONTROL` (otherwise off)
        # That skips `SwapScreenBuffer` and `PollInputEvents` from `EndDrawing`
        # In turn, normal `raylib-games` demos start but never present a window
        # Keep the default game loop behavior unless explicitly requested
        (lib.cmakeBool "SUPPORT_CUSTOM_FRAME_CONTROL" customFrameControlSupport)
        (lib.cmakeFeature "PLATFORM" platform)
      ]
      ++ optional (platform == "Desktop") (lib.cmakeFeature "USE_EXTERNAL_GLFW" "ON")
      ++ optional includeEverything (lib.cmakeBool "INCLUDE_EVERYTHING" true)
      ++ optional sharedLib (lib.cmakeBool "BUILD_SHARED_LIBS" true);

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
