{ stdenv, fetchgit , boost, libX11, mesa, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile }:

stdenv.mkDerivation rec {
  name = "zam-plugins-${version}";
  version = "3.7";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "932046905a57f698406318765a60807a1f81257d";
    sha256 = "0zgkmq3jgysrsb6cm6sfbgqpgfpwv8nxlgkqm29zzvb97j56bm7z";
  };

  buildInputs = [ boost libX11 mesa liblo libjack2 ladspaH lv2 pkgconfig rubberband libsndfile ];

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
