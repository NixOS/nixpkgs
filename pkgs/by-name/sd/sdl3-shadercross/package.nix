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
  version = "0-unstable-2025-12-06";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_shadercross";
    rev = "f1ca8cfefba8f32095861bbcf2a4f4d773f0fbb4";
    hash = "sha256-q0iEoN8+f438ScgAvobDh7evulfaZ3Cd8zkc19kRT54=";
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
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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
