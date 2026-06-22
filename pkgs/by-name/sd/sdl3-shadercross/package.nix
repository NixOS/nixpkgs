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
  version = "0-unstable-2026-06-15";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_shadercross";
    rev = "9a461644308366b50f0c364069d762be8e3b3443";
    hash = "sha256-oKetmnMb+SeRlscWmzGln6nR1M7fBkgybFlB1bh1Cos=";
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
