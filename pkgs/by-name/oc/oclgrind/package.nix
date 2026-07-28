{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_22,
  readline,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "oclgrind";
  version = "26.03.1";

  src = fetchFromGitHub {
    owner = "jrprice";
    repo = "oclgrind";
    rev = "v${version}";
    sha256 = "sha256-skly0JVwbqsC3YVwR+rUNlhNN2IdrcMsnTYh6HRE22s=";
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ python3 ];
  buildInputs = [
    llvmPackages_22.llvm
    llvmPackages_22.clang-unwrapped
    readline
  ];

  cmakeFlags = [
    "-DCLANG_ROOT=${llvmPackages_22.clang-unwrapped}"
    (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
  ];

  meta = with lib; {
    description = "OpenCL device simulator and debugger";
    homepage = "https://github.com/jrprice/oclgrind";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ athas ];
  };
}
