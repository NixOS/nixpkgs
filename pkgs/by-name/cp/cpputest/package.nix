{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "cpputest";
  version = "4.0";

  src = fetchurl {
    url = "https://github.com/cpputest/cpputest/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1xslavlb1974y5xvs8n1j9zkk05dlw8imy4saasrjlmibl895ii1";
  };

  meta = with lib; {
    homepage = "https://cpputest.github.io/";
    description = "Unit testing and mocking framework for C/C++";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [ maintainers.juliendehos ];
  };
}
