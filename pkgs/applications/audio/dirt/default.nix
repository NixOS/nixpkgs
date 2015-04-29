{ stdenv, fetchFromGitHub, libsndfile, libsamplerate, liblo, jack2 }:

stdenv.mkDerivation rec {
  name = "dirt-git";
  src = fetchFromGitHub {
    repo = "Dirt";
    owner = "tidalcycles";
    rev = "cfc5e85318defda7462192b5159103c823ce61f7";
    sha256 = "1shbyp54q64g6bsl6hhch58k3z1dyyy9ph6cq2xvdf8syy00sisz";
  };
  buildInputs = [ libsndfile libsamplerate liblo jack2 ];
  configurePhase = ''
    export DESTDIR=$out
  '';

  meta = {
    description = "An unimpressive thingie for playing bits of samples with some level of accuracy";
    homepage = "https://github.com/tidalcycles/Dirt";
    license = stdenv.lib.licenses.gpl3;
  };
}
