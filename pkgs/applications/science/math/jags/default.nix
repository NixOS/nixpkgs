{stdenv, fetchurl, gfortran, liblapack, blas}:

stdenv.mkDerivation rec {
  name = "JAGS-2.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/${name}.tar.gz";
    sha256 = "016xml4k99lmdwwjiabxin95k9p3q2zh4pcci8wwcqwlq5y205b6";
  };
  buildInputs = [gfortran liblapack blas];

  meta = {
    description = "JAGS: Just Another Gibbs Sampler";
    license     = "GPL2";
    homepage    = http://www-ice.iarc.fr/~martyn/software/jags/;
    maintainers = [stdenv.lib.maintainers.andres];
  };
}
