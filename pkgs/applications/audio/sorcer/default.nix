{ stdenv, fetchFromGitHub , boost, cairomm, cmake, libsndfile, lv2, ntk, pkgconfig, python }:

stdenv.mkDerivation rec {
  pname = "sorcer";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-Sorcer";
    rev = "release-${version}";
    sha256 = "1x7pi77nal10717l02qpnhrx6d7w5nqrljkn9zx5w7gpb8fpb3vp";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost cairomm cmake libsndfile lv2 ntk python ];

  postPatch = ''
     # Fix build with lv2 1.18: https://github.com/brummer10/guitarix/commit/c0334c72
     find . -type f -exec fgrep -q LV2UI_Descriptor {} \; \
       -exec sed -i {} -e 's/const struct _\?LV2UI_Descriptor/const LV2UI_Descriptor/' \;
   '';

  installPhase = ''
    make install
    cp -a ../presets/* "$out/lib/lv2"
  '';

  meta = with stdenv.lib; {
    homepage = "http://openavproductions.com/sorcer/";
    description = "A wavetable LV2 plugin synth, targeted at the electronic / dubstep genre";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
