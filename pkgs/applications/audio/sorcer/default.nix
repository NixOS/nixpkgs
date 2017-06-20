{ stdenv, fetchFromGitHub , boost, cairomm, cmake, libsndfile, lv2, ntk, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "sorcer-${version}";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-Sorcer";
    rev = "release-${version}";
    sha256 = "1x7pi77nal10717l02qpnhrx6d7w5nqrljkn9zx5w7gpb8fpb3vp";
  };

  buildInputs = [ boost cairomm cmake libsndfile lv2 ntk pkgconfig python ];

  installPhase = ''
    make install
    cp -a ../presets/* "$out/lib/lv2"
  '';

  meta = with stdenv.lib; {
    homepage = http://openavproductions.com/sorcer/;
    description = "A wavetable LV2 plugin synth, targeted at the electronic / dubstep genre";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
