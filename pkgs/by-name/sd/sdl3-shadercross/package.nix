{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  sdl3,
  spirv-cross,
  directx-shader-compiler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-shadercross";
  version = "0-unstable-2025-09-18";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_shadercross";
    rev = "3e572c3219ea438bff849cebea34f3aad7e1859b";
    hash = "sha256-m1A6JrNKLNXQWEBXYJOK7eQE1+BhhJIqOiKGrRrLxi0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    sdl3
    spirv-cross
    directx-shader-compiler
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "SDLSHADERCROSS_STATIC" true)
    (lib.cmakeBool "SDLSHADERCROSS_SHARED" true)
    (lib.cmakeBool "SDLSHADERCROSS_SPIRVCROSS_SHARED" true)
    (lib.cmakeBool "SDLSHADERCROSS_CLI" true)
    (lib.cmakeBool "SDLSHADERCROSS_DXC" true)
    (lib.cmakeBool "SDLSHADERCROSS_INSTALL" true)
  ];

  postInstall = ''
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp -P ${directx-shader-compiler}/lib/libdxcompiler.dylib $lib/lib/
    ''}
  '';

  postFixup = ''
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      for prog in $out/bin/*; do
        if [[ -f "$prog" ]]; then
          install_name_tool -add_rpath $lib/lib "$prog"
        fi
      done
    ''}
  '';

  doCheck = true;

  meta = {
    description = "Shader translation library";
    mainProgram = "shadercross";
    homepage = "https://libsdl.org";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ nyxonios ];
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.all;
  };
})
