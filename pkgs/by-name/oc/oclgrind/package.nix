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

  meta = with lib; {
    description = "OpenCL device simulator and debugger";
    homepage = "https://github.com/jrprice/oclgrind";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ athas ];
  };
}
