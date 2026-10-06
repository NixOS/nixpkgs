{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cunit,
  nodejs,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmysofa";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HxYSQNk7V0IQaZn/K1MdtSgL+7mxBNNPn7HNors5Vkk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  nativeCheckInputs = [ nodejs ];

  checkInputs = [ cunit ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Reader for AES SOFA files to get better HRTFs";
    homepage = "https://github.com/hoene/libmysofa";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
