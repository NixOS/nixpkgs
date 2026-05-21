{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  blasfeo,
  llvmPackages,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fatrop";
  version = "1.0.1.mod";

  src = fetchFromGitHub {
    owner = "meco-group";
    repo = "fatrop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2exJa9pKISDnq1MFLDV5My09BYEEN09slCTPtogd/f8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blasfeo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_BLASFEO" false)
  ];

  doCheck = true;

  checkInputs = [ gtest ];

  meta = {
    description = "Nonlinear optimal control problem solver that aims to be fast, support a broad class of optimal control problems and achieve a high numerical robustness";
    homepage = "https://github.com/meco-group/fatrop";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
