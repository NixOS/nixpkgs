{stdenv, fetchurl, gfortran, openblas}:

stdenv.mkDerivation rec {
  name = "JAGS-4.1.0";
  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/${name}.tar.gz";
    sha256 = "08pmrnbwibc0brgn5cx860jcl0s2xaw4amw7g45649r1bcdz7v25";
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
