{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  z3,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simbaplusplus";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "pgarba";
    repo = "SiMBA-";
    rev = "cbef1fc868d5de1b659ed317db9e0a1cecf6462b";
    hash = "sha256-GISI66DuNA7KYJ/trdSdx3CkjdqXn9mQs+EwVxSlgoE=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail ' ''${LLVM_TOOLS_BINARY_DIR}/llvm-config' " ${lib.getDev llvmPackages.libllvm}/bin/llvm-config" \
      --replace-fail 'set(Z3_INCLUDE_DIRS “/usr/include”)' ""
  '';

  # llvm-config --cxxflags exports -fno-exceptions, but z3's C++ headers require exception support.
  env.NIX_CFLAGS_COMPILE = "-fexceptions";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.libllvm
    z3
  ];

  checkInputs = [
    python3
  ];

  doCheck = true;

  meta = {
    description = "SiMBA++ is a port of MBA Solver SiMBA to C/C++";
    homepage = "https://github.com/pgarba/SiMBA-";
    license = lib.licenses.gpl3Only;
    mainProgram = "SiMBA++";
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
})
