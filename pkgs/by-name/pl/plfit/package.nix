{
  cmake,
  fetchFromGitHub,
  lib,
  llvmPackages,
  withPython ? false,
  python ? null,
  stdenv,
  swig,
}:

assert withPython -> python != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "plfit";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ntamas";
    repo = "plfit";
    rev = finalAttrs.version;
    hash = "sha256-0JrPAq/4yzr7XbxvcnFj8CKmMyZT05PkSdGprNdAsJA=";
  };

  postPatch = lib.optionalString withPython ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail ' ''${Python3_SITEARCH}' ' ${placeholder "out"}/${python.sitePackages}' \
      --replace-fail ' ''${Python3_SITELIB}' ' ${placeholder "out"}/${python.sitePackages}'
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withPython [
    python
    swig
  ];

  cmakeFlags = [
    "-DPLFIT_USE_OPENMP=ON"
  ]
  ++ lib.optionals withPython [
    "-DPLFIT_COMPILE_PYTHON_MODULE=ON"
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  doCheck = true;

  meta = {
    description = "Fitting power-law distributions to empirical data";
    homepage = "https://github.com/ntamas/plfit";
    changelog = "https://github.com/ntamas/plfit/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
