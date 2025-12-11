{
  lib,
  stdenv,
  fetchurl,
  cmake,
  clang,
}:

stdenv.mkDerivation rec {
  pname = "alglib3";
  version = "4.06.0";

  src = fetchurl {
    url = "https://www.alglib.net/translator/re/alglib-${version}.cpp.gpl.tgz";
    sha256 = "sha256-J/pLC4Fgy7Ks5PadGo7wmQz4lMh9/z9G3IbsisLTDGg=";
  };

  nativeBuildInputs = [
    cmake
    clang
  ];

  patches = [
    ./patch-alglib-CMakeLists.patch
  ];

  meta = {
    description = "Numerical analysis and data processing library for c++";
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
}
