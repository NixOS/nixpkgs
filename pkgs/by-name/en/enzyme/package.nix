{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  git,
}:
stdenv.mkDerivation rec {
  pname = "enzyme";
  version = "0.0.121";

  src = fetchFromGitHub {
    owner = "EnzymeAD";
    repo = "Enzyme";
    rev = "v${version}";
    hash = "sha256-hCgrPMxclnLHlOiGFeZ6MAAEUqU8nzxYwT1wbuPPXCw=";
  };

  postPatch = ''
    patchShebangs enzyme
  '';

  nativeBuildInputs = [cmake git];

  buildInputs = with llvmPackages; [llvm libclang];

  cmakeFlags = [
    "-S../enzyme"
    "-DLLVM_DIR=${llvmPackages.llvm.dev}"
    "-DClang_DIR=${llvmPackages.libclang.dev}"
  ];

  meta = with lib; {
    homepage = "https://enzyme.mit.edu/";
    description = "High-performance automatic differentiation of LLVM and MLIR.";
    maintainers = with maintainers; [kiranshila];
    platforms = platforms.all;
    license = licenses.asl20-llvm;
  };
}
