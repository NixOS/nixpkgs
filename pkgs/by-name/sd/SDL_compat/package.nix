{
  lib,
  SDL2,
  cmake,
  darwin,
  fetchFromGitHub,
  libGLU,
  libiconv,
  mesa,
  pkg-config,
  stdenv,
  # Boolean flags
  libGLSupported ? lib.elem stdenv.hostPlatform.system mesa.meta.platforms,
  openglSupport ? libGLSupported,
}:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
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

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ];

  propagatedBuildInputs =
    [ SDL2 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Cocoa
    ]
    ++ lib.optionals openglSupport [ libGLU ];

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  postFixup = ''
    for lib in $out/lib/*${stdenv.hostPlatform.extensions.sharedLibrary}* ; do
      if [[ -L "$lib" ]]; then
        ${
          if stdenv.hostPlatform.isDarwin then
            ''
              install_name_tool ${
                lib.strings.concatMapStrings (
                  x: " -add_rpath ${lib.makeLibraryPath [ x ]} "
                ) finalAttrs.propagatedBuildInputs
              } "$lib"
            ''
          else
            ''
              patchelf --set-rpath "$(patchelf --print-rpath $lib):${lib.makeLibraryPath finalAttrs.propagatedBuildInputs}" "$lib"
            ''
        }
      fi
    done
  '';

  meta = {
    homepage = "https://www.libsdl.org/";
    description = "Cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    license = lib.licenses.zlib;
    mainProgram = "sdl-config";
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ peterhoeg ]);
    platforms = lib.platforms.all;
  };
})
