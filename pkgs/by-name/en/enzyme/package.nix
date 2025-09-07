{
  lib,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  git,
}:
llvmPackages.stdenv.mkDerivation rec {
  pname = "enzyme";
  version = "0.0.195";

  src = fetchFromGitHub {
    owner = "EnzymeAD";
    repo = "Enzyme";
    rev = "v${version}";
    hash = "sha256-3plYgsXsP/7fexjyEGIowYBymk+ikdJumQdqBcm1Ljg=";
  };

  postPatch = ''
    patchShebangs enzyme
  '';

  llvm = llvmPackages.llvm;
  clang = llvmPackages.clang-unwrapped;

  buildInputs = [
    cmake
    git
    llvm
    clang
  ];

  cmakeDir = "../enzyme";

  cmakeFlags = [
    "-DLLVM_DIR=${llvm.dev}"
    "-DClang_DIR=${clang.dev}"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://enzyme.mit.edu/";
    description = "High-performance automatic differentiation of LLVM and MLIR";
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
  };
}
