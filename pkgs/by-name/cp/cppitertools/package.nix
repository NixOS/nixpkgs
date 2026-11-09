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
  version = "2.3";

  src = fetchFromGitHub {
    owner = "ryanhaining";
    repo = "cppitertools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1lHpy+9e17lP/58EEIzrmyBwbmMD665ypDJtkSFrN9E=";
  };

  __structuredAttrs = true;

  # cppitertools has support files for three buildsystems in its repo:
  # Scons, Bazel, and CMake. The first two only have definitions for running
  # tests. The CMake system defines tests and install targets, including a
  # cppitertools-config.cmake, which is really helpful for downstream consumers
  # to detect this package since it has no pkg-config.

  strictDeps = true;

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  nativeCheckInputs = [ catch2 ];

  # Required on case-sensitive filesystems to not conflict with the Bazel BUILD
  # files that are also in that repo.
  cmakeBuildDir = "cmake-build";

  cmakeInstallDir = "${placeholder "out"}/share/cmake";

  # This version of cppitertools considers itself as having used the default value,
  # and issues warning, unless -Dcppitertools_INSTALL_CMAKE_DIR is present as an
  # *environment* variable. It doesn't actually use the value from this environment
  # variable at all though, so we still need to pass it in cmakeFlags.
  env.cppitertools_INSTALL_CMAKE_DIR = finalAttrs.cmakeInstallDir;

  cmakeFlags = [ "-Dcppitertools_INSTALL_CMAKE_DIR=${finalAttrs.cmakeInstallDir}" ];

  prePatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
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
    cmake --install . "--prefix=$out"
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
