{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CzHE2d0CtScexdIw95zHKY1Ao8xFodtfSNNkM6dNCac=";
  };

  # CMake Error in CMakeLists.txt:
  #   Imported target "highs::highs" includes non-existent path
  #     "/include"
  #   in its INTERFACE_INCLUDE_DIRECTORIES.
  postPatch = ''
    sed -i "/CMAKE_CUDA_PATH/d" src/CMakeLists.txt
  '';

  strictDeps = true;

  outputs = [ "out" ];

  doInstallCheck = true;

  installCheckPhase = ''
    "$out/bin/highs" --version
  '';

  nativeBuildInputs = [
    clang
    cmake
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ERGO-Code/HiGHS";
    description = "Linear optimization software";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "highs";
    maintainers = with maintainers; [ silky ];
  };
})
