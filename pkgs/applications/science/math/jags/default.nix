{stdenv, fetchurl, gfortran, openblas}:

stdenv.mkDerivation rec {
  name = "JAGS-3.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/${name}.tar.gz";
    sha256 = "0ayqsz9kkmbss7mxlwr34ch2z1vsb65lryjzqpprab1ccyiaksib";
  };
  buildInputs = [gfortran openblas];
  configureFlags = [ "--with-blas=-lopenblas" "--with-lapack=-lopenblas" ];

  meta = {
    description = "Just Another Gibbs Sampler";
    license     = "GPL2";
    homepage    = http://www-ice.iarc.fr/~martyn/software/jags/;
    maintainers = [stdenv.lib.maintainers.andres];
  };
}
