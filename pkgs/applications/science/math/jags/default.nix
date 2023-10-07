{ lib, stdenv, fetchurl, gfortran, blas, lapack }:

stdenv.mkDerivation rec {
  pname = "JAGS";
  version = "4.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/mcmc-jags/JAGS-${version}.tar.gz";
    sha256 = "sha256-hx9VavQDp8LOag8C8Vz4WlcnY+CT0mZY66xVxKtHL8g=";
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
