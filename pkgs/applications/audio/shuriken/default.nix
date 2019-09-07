{ stdenv, fetchFromGitHub, qmake, alsaLib, jack2, rubberband, aubio, libsndfile
, liblo, libsamplerate }:

stdenv.mkDerivation rec {
  name = "shuriken-${version}";
  version = "0.5.2";
  src = fetchFromGitHub {
    owner = "rock-hopper";
    repo = "shuriken";
    rev = "v${version}";
    sha256 = "1mvrh6zp0fwii96kv3qfga5kvy7imxkccq51iy6qnbf7bxfkb52s";
  };

  nativeBuildInputs = [ qmake ];
  qmakeFlags = [ "./Shuriken.pro" ];
  buildInputs = [ alsaLib jack2 rubberband aubio libsndfile liblo libsamplerate ];

  preBuild = ''
    mkdir -p lib
    pushd src/SndLibShuriken
    ./configure --without-audio --without-s7
    make -w
    mv -v libsndlib_shuriken.a ../../lib/
    popd
  '';

  meta = with stdenv.lib; {
    description = "Shuriken beat slicer";
    homepage = https://github.com/rock-hopper/shuriken;
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
