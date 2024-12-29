{
  cmake,
  fetchFromGitHub,
  lib,
  llvmPackages,
  python ? null,
  stdenv,
  swig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plfit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ntamas";
    repo = "plfit";
    rev = finalAttrs.version;
    hash = "sha256-ur+ai0in7PaoDZcPzuUzQTrZ3nB0H5FDSfPBpl1e9ug=";
  };

  postPatch = lib.optionalString (python != null) ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail ' ''${Python3_SITEARCH}' ' ${placeholder "out"}/${python.sitePackages}' \
      --replace-fail ' ''${Python3_SITELIB}' ' ${placeholder "out"}/${python.sitePackages}'
  '';

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals (python != null) [
      python
      swig
    ];

  cmakeFlags =
    [
      "-DPLFIT_USE_OPENMP=ON"
    ]
    ++ lib.optionals (python != null) [
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
