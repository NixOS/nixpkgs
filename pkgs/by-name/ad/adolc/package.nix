{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adolc";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "ADOL-C";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-oU229SuOl/gHoRT8kiWfd5XFiByjeypgdVWFLMYFHfA=";
  };

  configureFlags = [
    "--with-openmp-flag=-fopenmp"
    "--enable-sparse"
  ];

  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  meta = {
    description = "Automatic Differentiation of C/C++";
    homepage = "https://github.com/coin-or/ADOL-C";
    maintainers = with lib.maintainers; [ bzizou ];
    license = lib.licenses.gpl2Plus;
  };
})
