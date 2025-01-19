{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_12,
  readline,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "oclgrind";
  version = "21.10";

  src = fetchFromGitHub {
    owner = "jrprice";
    repo = "oclgrind";
    rev = "v${version}";
    sha256 = "sha256-DGCF7X2rPV1w9guxg2bMylRirXQgez24sG7Unlct3ow=";
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ python3 ];
  buildInputs = [
    llvmPackages_12.llvm
    llvmPackages_12.clang-unwrapped
    readline
  ];

  cmakeFlags = [
    "-DCLANG_ROOT=${llvmPackages_12.clang-unwrapped}"
  ];

  meta = {
    description = "OpenCL device simulator and debugger";
    homepage = "https://github.com/jrprice/oclgrind";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ athas ];
  };
}
