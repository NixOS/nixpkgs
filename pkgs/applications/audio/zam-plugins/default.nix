{ stdenv, fetchgit , boost, libX11, mesa, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile }:

stdenv.mkDerivation rec {
  name = "zam-plugins-${version}";
  version = "3.6";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "91fe56931a3e57b80f18c740d2dde6b44f962aee";
    sha256 = "17slpywjs04xbcylyqjg6kqbpqwqbigf843y437yfvj1ar6ir1jp";
  };

  buildInputs = [ boost libX11 mesa liblo libjack2 ladspaH lv2 pkgconfig rubberband libsndfile ];

  patchPhase = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
    substituteInPlace Makefile --replace "ZaMaximX2" "ZaMaximX2 ZamPiano ZamChild670"
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
