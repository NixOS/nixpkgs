{ stdenv, fetchgit , boost, libX11, mesa, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile }:

stdenv.mkDerivation rec {
  name = "zam-plugins-${version}";
  version = "3.8";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "830ab2e9dd1db8cf56d12c71057157e5d8e9fd74";
    sha256 = "1hyly5inis59cvh0r7lyi203h8v5jh84ca9jpaljm53cvw6d93px";
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
