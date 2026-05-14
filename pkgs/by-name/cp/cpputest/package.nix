{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpputest";
  version = "4.0";

  src = fetchurl {
    url = "https://github.com/cpputest/cpputest/releases/download/v${finalAttrs.version}/cpputest-${finalAttrs.version}.tar.gz";
    sha256 = "1xslavlb1974y5xvs8n1j9zkk05dlw8imy4saasrjlmibl895ii1";
  };

  meta = {
    homepage = "https://cpputest.github.io/";
    description = "Unit testing and mocking framework for C/C++";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.juliendehos ];
  };
})
