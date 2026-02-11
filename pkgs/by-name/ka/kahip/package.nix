{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  mpi,
  metis,
  llvmPackages,
  python3Packages,
  pythonSupport ? false,
  isILP64 ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kahip";
  version = "3.22";

  src = fetchFromGitHub {
    owner = "KaHIP";
    repo = "KaHIP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uZRNATfrQgAn5Wsmpk9tU0ojXHbLJ8DOOuXRJJhkhFM=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optional pythonSupport python3Packages.python;

  buildInputs = [
    mpi
    metis
  ]
  ++ lib.optional pythonSupport python3Packages.pybind11
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  # create meta package providing dist-info for python3Pacakges.kahip that common cmake build does not do
  propagatedBuildInputs = lib.optional pythonSupport (
    python3Packages.mkPythonMetaPackage {
      inherit (finalAttrs) pname version meta;
    }
  );

  cmakeFlags = [
    (lib.cmakeBool "64BITMODE" isILP64)
    (lib.cmakeBool "NONATIVEOPTIMIZATIONS" true)
    (lib.cmakeBool "BUILDPYTHONMODULE" pythonSupport)
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHONDIR" python3Packages.python.sitePackages)
  ];

  postInstall = lib.optionalString pythonSupport ''
    cp ../python/kahip/* $out/${python3Packages.python.sitePackages}/kahip
    echo "__version__= '${finalAttrs.version}'" > $out/${python3Packages.python.sitePackages}/kahip/_version.py
  '';

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
