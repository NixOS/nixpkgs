{ lib, stdenv, fetchurl, gfortran, blas, lapack }:

stdenv.mkDerivation rec {
  pname = "JAGS";
  version = "4.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/JAGS-${version}.tar.gz";
    sha256 = "1z3icccg2ic56vmhyrpinlsvpq7kcaflk1731rgpvz9bk1bxvica";
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ blas lapack ];

  configureFlags = [ "--with-blas=-lblas" "--with-lapack=-llapack" ];

  meta = with lib; {
    description = "Just Another Gibbs Sampler";
    license = licenses.gpl2;
    homepage = "http://mcmc-jags.sourceforge.net";
    maintainers = [ maintainers.andres ];
    platforms = platforms.unix;
  };
}
