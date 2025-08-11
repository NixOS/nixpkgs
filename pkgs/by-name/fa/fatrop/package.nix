{
  blasfeo,
  cmake,
  fetchFromGitHub,
  lib,
  llvmPackages,
  python3Packages,
  pythonSupport ? false,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fatrop";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "meco-group";
    repo = "fatrop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XVOS9L2vQeFkPXZieX1ZJiVagR0f2BtiRmSDPB9LQeI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blasfeo
  ]
  ++ lib.optionals pythonSupport [ python3Packages.pybind11 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" true)
    (lib.cmakeBool "ENABLE_MULTITHREADING" true)
    (lib.cmakeBool "BUILD_WITH_BLASFEO" false)
    (lib.cmakeBool "WITH_PYTHON" pythonSupport)
    (lib.cmakeBool "WITH_SPECTOOL" false) # this depends on casadi
  ];

  doCheck = true;

  meta = {
    description = "Nonlinear optimal control problem solver that aims to be fast, support a broad class of optimal control problems and achieve a high numerical robustness";
    homepage = "https://github.com/meco-group/fatrop";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
