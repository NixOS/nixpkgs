{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, SDL2
, libiconv
, mesa
, libGLSupported ? lib.elem stdenv.hostPlatform.system mesa.meta.platforms
, openglSupport ? libGLSupported
, libGLU
, SDL1
, darwin
}:

let
  inherit (lib) optionals makeLibraryPath;
  inherit (darwin.apple_sdk.frameworks) Cocoa;
  inherit (darwin) autoSignDarwinBinariesHook;
in
stdenv.mkDerivation rec {
  pname = "SDL_compat";
  version = "1.2.68";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl12-compat";
    rev = "release-" + version;
    hash = "sha256-f2dl3L7/qoYNl4sjik1npcW/W09zsEumiV9jHuKnUmM=";
  };

  nativeBuildInputs = [ cmake pkg-config ]
    ++ optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ];

  propagatedBuildInputs = [ SDL2 ]
    ++ optionals stdenv.hostPlatform.isDarwin [ libiconv Cocoa ]
    ++ optionals openglSupport [ libGLU ];

  enableParallelBuilding = true;

  inherit (SDL1) setupHook;

  postFixup = ''
    for lib in $out/lib/*${stdenv.hostPlatform.extensions.sharedLibrary}* ; do
      if [[ -L "$lib" ]]; then
        ${if stdenv.hostPlatform.isDarwin then ''
          install_name_tool ${lib.strings.concatMapStrings (x: " -add_rpath ${makeLibraryPath [x]} ") propagatedBuildInputs} "$lib"
        '' else ''
          patchelf --set-rpath "$(patchelf --print-rpath $lib):${makeLibraryPath propagatedBuildInputs}" "$lib"
        ''}
      fi
    done
  '';

  meta = {
    description = "Cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    homepage = "https://www.libsdl.org/";
    license = lib.licenses.zlib;
    mainProgram = "sdl-config";
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
  };
}
