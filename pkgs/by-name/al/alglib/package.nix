{
  lib,
  stdenv,
  fetchurl,
  cmake,
  clang,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alglib3";
  version = "4.07.0";

  src = fetchurl {
    url = "https://www.alglib.net/translator/re/alglib-${finalAttrs.version}.cpp.gpl.tgz";
    sha256 = "sha256-y4mlU+4gKwqUFgUHKoVxAjdq5EsMzSJeT6Dg4Llwi/A=";
  };

  nativeBuildInputs = [
    cmake
    clang
  ];

  patches = [
    ./patch-alglib-CMakeLists.patch
  ];

  meta = {
    description = "Numerical analysis and data processing library";
    homepage = "https://www.alglib.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.paperdigits ];
    longDescription = ''
      ALGLIB is a cross-platform numerical analysis and data processing library. It supports several programming languages (C++, C#, Delphi) and several operating systems (Windows and POSIX, including Linux). ALGLIB features include:

      * Data analysis (classification/regression, statistics)
      * Optimization and nonlinear solvers
      * Interpolation and linear/nonlinear least-squares fitting
      * Linear algebra (direct algorithms, EVD/SVD), direct and iterative linear solvers
      * Fast Fourier Transform and many other algorithms
    '';
  };
})
