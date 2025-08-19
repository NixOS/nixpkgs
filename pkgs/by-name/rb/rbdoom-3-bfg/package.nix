{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  directx-shader-compiler,
  ispc,
  ncurses,
  openal,
  rapidjson,
  SDL2,
  vulkan-headers,
  vulkan-loader,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "rbdoom-3-bfg";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "RobertBeckebans";
    repo = "rbdoom-3-bfg";
    tag = "v${version}";
    hash = "sha256-9BZEFO+e5IG6hv9+QI9OJecQ84rLTWBDz4k0GU6SeDE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace neo/extern/nvrhi/tools/shaderCompiler/CMakeLists.txt \
      --replace "AppleClang" "Clang"
  '';

  nativeBuildInputs = [
    cmake
    directx-shader-compiler
    ispc
  ];

  buildInputs = [
    ncurses
    openal
    rapidjson
    SDL2
    vulkan-headers
    vulkan-loader
    zlib
  ];

  cmakeDir = "../neo";
  cmakeFlags = [
    "-DFFMPEG=OFF"
    "-DBINKDEC=ON"
    "-DUSE_SYSTEM_RAPIDJSON=ON"
    "-DUSE_SYSTEM_ZLIB=ON"
  ];

  # it caused build failure
  hardeningDisable = [ "fortify3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install RBDoom3BFG $out/bin/RBDoom3BFG

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/RobertBeckebans/RBDOOM-3-BFG";
    description = "Doom 3 BFG Edition with modern engine features";
    mainProgram = "RBDoom3BFG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Zaechus ];
    platforms = platforms.unix;
  };
}
