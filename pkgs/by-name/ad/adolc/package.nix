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
    rev = "refs/tags/releases/${finalAttrs.version}";
    hash = "sha256-oU229SuOl/gHoRT8kiWfd5XFiByjeypgdVWFLMYFHfA=";
  };

  configureFlags = [
    "--with-openmp-flag=-fopenmp"
    "--enable-sparse"
  ];

  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  meta = with lib; {
    description = "Automatic Differentiation of C/C++";
    homepage = "https://github.com/coin-or/ADOL-C";
    maintainers = [ maintainers.bzizou ];
    license = licenses.gpl2Plus;
  };
})
