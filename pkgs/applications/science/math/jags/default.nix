{stdenv, fetchurl, gfortran, openblas}:

stdenv.mkDerivation rec {
  name = "JAGS-4.3.0";
  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/${name}.tar.gz";
    sha256 = "1z3icccg2ic56vmhyrpinlsvpq7kcaflk1731rgpvz9bk1bxvica";
  };
  buildInputs = [gfortran openblas];
  configureFlags = [ "--with-blas=-lopenblas" "--with-lapack=-lopenblas" ];

  meta = {
    description = "Just Another Gibbs Sampler";
    license     = "GPL2";
    homepage    = http://www-ice.iarc.fr/~martyn/software/jags/;
    maintainers = [stdenv.lib.maintainers.andres];
    platforms = stdenv.lib.platforms.unix;
  };
}
