{ stdenv, fetchFromGitHub, libsndfile, libsamplerate, liblo, libjack2 }:

stdenv.mkDerivation rec {
  name = "dirt-2015-04-28";
  src = fetchFromGitHub {
    repo = "Dirt";
    owner = "tidalcycles";
    rev = "cfc5e85318defda7462192b5159103c823ce61f7";
    sha256 = "1shbyp54q64g6bsl6hhch58k3z1dyyy9ph6cq2xvdf8syy00sisz";
  };
  buildInputs = [ libsndfile libsamplerate liblo libjack2 ];
  postPatch = ''
    sed -i "s|./samples|$out/share/dirt/samples|" file.h
  '';
  configurePhase = ''
    export DESTDIR=$out
  '';
  postInstall = ''
    mkdir -p $out/share/dirt/
    cp -r samples $out/share/dirt/
  '';

  meta = with stdenv.lib; {
    description = "An unimpressive thingie for playing bits of samples with some level of accuracy";
    homepage = https://github.com/tidalcycles/Dirt;
    license = licenses.gpl3;
    maintainers = with maintainers; [ anderspapitto ];
    platforms = with platforms; linux;
  };
}
