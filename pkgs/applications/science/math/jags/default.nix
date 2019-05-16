{stdenv, fetchurl, gfortran, openblas}:

stdenv.mkDerivation rec {
  name = "JAGS-4.3.0";
  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/${name}.tar.gz";
    sha256 = "1z3icccg2ic56vmhyrpinlsvpq7kcaflk1731rgpvz9bk1bxvica";
  };
  buildInputs = [gfortran openblas];
  configureFlags = [ "--with-blas=-lopenblas" "--with-lapack=-lopenblas" ];

  meta = with stdenv.lib; {
    description = "Just Another Gibbs Sampler";
    license     = licenses.gpl2;
    homepage    = http://mcmc-jags.sourceforge.net;
    maintainers = [ maintainers.andres ];
    platforms = platforms.unix;
  };
}
