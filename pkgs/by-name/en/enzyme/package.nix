{
  lib,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  git,
}:
llvmPackages.stdenv.mkDerivation rec {
  pname = "enzyme";
  version = "0.0.172";

  src = fetchFromGitHub {
    owner = "EnzymeAD";
    repo = "Enzyme";
    rev = "v${version}";
    hash = "sha256-/FxjXCML7hBNYOVf1PLG+VwCdaNGYwwirRJSQxIvLcg=";
  };

  postPatch = ''
    patchShebangs enzyme
  '';

  nativeBuildInputs = [
    cmake
    git
    llvmPackages.llvm
  ];

  cmakeDir = "../enzyme";

  cmakeFlags = [ "-DLLVM_DIR=${llvmPackages.llvm.dev}" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://enzyme.mit.edu/";
    description = "High-performance automatic differentiation of LLVM and MLIR";
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
    license = lib.licenses.asl20-llvm;
  };
}
