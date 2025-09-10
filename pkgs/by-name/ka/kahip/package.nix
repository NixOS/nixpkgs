{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  mpi,
  metis,
  python3Packages,
  pythonSupport ? false,
  isILP64 ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kahip";
  version = "3.18";

  src = fetchFromGitHub {
    owner = "KaHIP";
    repo = "KaHIP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l8DhVb2G6pQQcH3Wq4NsKw30cSK3sG+gCYRdpibw4ZI=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/KaHIP/KaHIP/commit/9d4978c7540a1ccbc9807367d6e3852114e86567.patch?full_index=1";
      hash = "sha256-nIJL0YmVp9+JUhzEXjoabD1qNEnhtrBnjMWnitYt0eU=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pybind11
  ];

  buildInputs = [
    mpi
    metis
  ];

  cmakeFlags = [
    (lib.cmakeBool "64BITMODE" isILP64)
    (lib.cmakeBool "BUILDPYTHONMODULE" pythonSupport)
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHONDIR" python3Packages.python.sitePackages)
  ];

  doInstallCheck = pythonSupport;

  nativeInstallCheckInputs = lib.optionals pythonSupport [
    python3Packages.pythonImportsCheckHook
  ];

  pythonImportsCheck = [ "kahip" ];

  meta = {
    homepage = "https://kahip.github.io/";
    downloadPage = "https://github.com/KaHIP/KaHIP/";
    changelog = "https://github.com/KaHIP/KaHIP/releases/tag/v${finalAttrs.version}";
    description = "Karlsruhe HIGH Quality Partitioning";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
