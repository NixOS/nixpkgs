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
    tag = "v${version}";
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

  meta = {
    description = "OpenCL device simulator and debugger";
    homepage = "https://github.com/jrprice/oclgrind";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ athas ];
  };
}
