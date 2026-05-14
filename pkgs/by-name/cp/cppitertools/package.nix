{
  lib,
  stdenv,
  cmake,
  boost,
  catch2,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppitertools";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "ryanhaining";
    repo = "cppitertools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mii4xjxF1YC3H/TuO/o4cEz8bx2ko6U0eufqNVw5LNA=";
  };

  __structuredAttrs = true;

  # cppitertools has support files for three buildsystems in its repo:
  # Scons, Bazel, and CMake. The first two only have definitions for running
  # tests. The CMake system defines tests and install targets, including a
  # cppitertools-config.cmake, which is really helpful for downstream consumers
  # to detect this package since it has no pkg-config.
  # However the CMake system also specifies the entire source repo as an install
  # target, including support files, the build directory, etc.
  # We can't simply take cppitertools-config.cmake for ourselves because before
  # install it's placed in non-specific private CMake subdirectory of the build
  # directory.
  # Therefore, we instead simply patch CMakeLists.txt to make the target that
  # installs the entire directory non-default, and then install the headers manually.

  strictDeps = true;

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  nativeCheckInputs = [ catch2 ];

  # Required on case-sensitive filesystems to not conflict with the Bazel BUILD
  # files that are also in that repo.
  cmakeBuildDir = "cmake-build";

  includeInstallDir = "${placeholder "out"}/include/cppitertools";
  cmakeInstallDir = "${placeholder "out"}/share/cmake";

  # This version of cppitertools considers itself as having used the default value,
  # and issues warning, unless -Dcppitertools_INSTALL_CMAKE_DIR is present as an
  # *environment* variable. It doesn't actually use the value from this environment
  # variable at all though, so we still need to pass it in cmakeFlags.
  env.cppitertools_INSTALL_CMAKE_DIR = finalAttrs.cmakeInstallDir;

  cmakeFlags = [ "-Dcppitertools_INSTALL_CMAKE_DIR=${finalAttrs.cmakeInstallDir}" ];

  prePatch = ''
    # Mark the `.` install target as non-default.
    substituteInPlace CMakeLists.txt \
      --replace-fail "  DIRECTORY ." "  DIRECTORY . EXCLUDE_FROM_ALL"
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    # Required for tests.
    cp ${lib.getDev catch2}/include/catch2/catch.hpp test/
  '';

  checkPhase = ''
    runHook preCheck
    cmake -B build-test -S ../test
    cmake --build build-test -j$NIX_BUILD_CORES
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    # Install the -config.cmake files.
    cmake --install . "--prefix=$out"
    # Install the headers.
    mkdir -p "$includeInstallDir"
    cp -r ../*.hpp ../internal "$includeInstallDir"
    runHook postInstall
  '';

  meta = {
    description = "Implementation of Python itertools and builtin iteration functions for C++17";
    longDescription = ''
      Range-based for loop add-ons inspired by the Python builtins and itertools library
      for C++17, using lazy evaluation wherever possible.
    '';
    homepage = "https://github.com/ryanhaining/cppitertools";
    maintainers = with lib.maintainers; [ qyriad ];
    license = with lib.licenses; bsd2;
  };
})
