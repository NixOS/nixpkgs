{ stdenv, fetchurl, boost, libX11, mesa, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile }:

stdenv.mkDerivation rec {
  name = "zam-plugins-${version}";
  version = "3.5";

  src = fetchurl {
    url = "https://github.com/zamaudio/zam-plugins/archive/${version}.tar.gz";
    sha256 = "0icdrs4vaaj8gqi76jkkx5yk9h3agipa11cyb5h52y814q6mx6vm";
  };

  buildInputs = [ boost libX11 mesa liblo libjack2 ladspaH lv2 pkgconfig rubberband libsndfile ];

  patchPhase = ''
    patchShebangs ./libs/generate-ttl.sh
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
