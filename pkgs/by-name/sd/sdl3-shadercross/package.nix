{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  sdl3,
  spirv-cross,
  directx-shader-compiler,
  nix-update-script,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-shadercross";
  version = "0-unstable-2026-04-24";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_shadercross";
    rev = "6b06e55c7c5d7e7a09a8a14f76e866dcfad5ab99";
    hash = "sha256-DvgMnE0QedInYRdcZQuVOlasri79kVl0ACGvNC1cq8o=";
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
    (lib.cmakeBool "SDLSHADERCROSS_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "SDLSHADERCROSS_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "SDLSHADERCROSS_INSTALL" true)
    (lib.cmakeBool "SDLSHADERCROSS_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  passthru.tests.example = runCommand "compile-spv-example" { } ''
    cat > example.vert.hlsl << EOF
    struct Input
    {
        float4 position : POSITION;
        float3 color : COLOR;
    };
    float3 main(in Input IN) : COLOR
    {
        return IN.color;
    };
    EOF
    ${lib.getExe finalAttrs.finalPackage} example.vert.hlsl -o example.spv
    touch $out
  '';

  meta = {
    description = "Shader translation library";
    mainProgram = "shadercross";
    homepage = "https://github.com/libsdl-org/SDL_shadercross";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ nyxonios ];
    teams = [ lib.teams.sdl ];
    platforms = lib.platforms.linux;
  };
})
