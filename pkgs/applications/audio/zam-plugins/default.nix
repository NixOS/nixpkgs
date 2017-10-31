{ stdenv, fetchgit , boost, libX11, mesa, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile }:

stdenv.mkDerivation rec {
  name = "zam-plugins-${version}";
  version = "3.9";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "4976cf204074c1dfaf344821e83e8d896b35107d";
    sha256 = "1xgwl51sf2hgc5ikcnycyxaw9vy82lrcswn07b6av6i67qclm8f8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libX11 mesa liblo libjack2 ladspaH lv2 rubberband libsndfile ];

  patchPhase = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.zamaudio.com/?p=976;
    description = "A collection of LV2/LADSPA/VST/JACK audio plugins by ZamAudio";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
