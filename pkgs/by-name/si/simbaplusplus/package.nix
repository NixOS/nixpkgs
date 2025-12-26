{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  llvmPackages,
  z3,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simbaplusplus";
  version = "0-unstable-2024-11-05";

  src = fetchFromGitHub {
    owner = "pgarba";
    repo = "SiMBA-";
    rev = "a030a187df0b650718b2aab18ccebc1f810e18b4";
    hash = "sha256-h2in203bwfb7ArhoBN0PoWM6DZtxI4jSGQuSTTaBJ7A=";
  };

  patches = [
    # CMakeLists: minimum cmake version 3.5
    (fetchpatch {
      url = "https://github.com/pgarba/SiMBA-/commit/0d5dcaf0a0e85e342141a9c525cc8a10934c2f9d.patch?full_index=1";
      hash = "sha256-rL/jzq4eoJI6j1aEK8vg6b2uqGjxN6P+8vsC8oYTxng=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail ' ''${LLVM_TOOLS_BINARY_DIR}/llvm-config' " ${lib.getDev llvmPackages.libllvm}/bin/llvm-config" \
      --replace-fail 'set(Z3_INCLUDE_DIRS “/usr/include”)' ""
  '';

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
