{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpkgmanifest";
  version = "0.5.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "libpkgmanifest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NWuUu1By7MORITgqac09cOMYrVB91xqiUgxN+7sDPMw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    yaml-cpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_DOCS" false)
    (lib.cmakeBool "WITH_PYTHON" false)
    (lib.cmakeBool "WITH_TESTS" false)
    (lib.cmakeBool "WITH_CODE_COVERAGE" false)
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  meta = {
    description = "Library for working with RPM manifests";
    homepage = "https://github.com/rpm-software-management/libpkgmanifest";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "libpkgmanifest";
    platforms = lib.platforms.all;
  };
})
