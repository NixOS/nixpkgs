{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libcxxCmakeModule ? false,
}:

stdenv.mkDerivation {
  pname = "cpptoml";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "skystrife";
    repo = "cpptoml";
    rev = "fededad7169e538ca47e11a9ee9251bc361a9a65";
    sha256 = "0zlgdlk9nsskmr8xc2ajm6mn1x5wz82ssx9w88s02icz71mcihrx";
  };

  patches = [
    # Fix compilation with GCC 11.
    # <https://github.com/skystrife/cpptoml/pull/123>
    ./add-limits-include.patch
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # If this package is built with clang it will attempt to
    # use libcxx via the Cmake find_package interface.
    # The default libcxx stdenv in llvmPackages doesn't provide
    # this and so will fail.
    "-DENABLE_LIBCXX=${if libcxxCmakeModule then "ON" else "OFF"}"
    "-DCPPTOML_BUILD_EXAMPLES=OFF"
  ];

  # Fix the build with CMake 4.
  #
  # See:
  #
  # * <https://github.com/skystrife/cpptoml/pull/132>
  # * <https://github.com/facebook/watchman/issues/1286>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.1.0)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  meta = with lib; {
    description = "C++ TOML configuration library";
    homepage = "https://github.com/skystrife/cpptoml";
    license = licenses.mit;
    maintainers = with maintainers; [ photex ];
    platforms = platforms.all;
  };
}
