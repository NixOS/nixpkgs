{ stdenv, fetchgit , boost, libX11, libGL, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile, fftwFloat, libsamplerate }:

stdenv.mkDerivation {
  pname = "zam-plugins";
  version = "3.11";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "af338057e42dd5d07cba1889bfc74eda517c6147";
    sha256 = "1qbskhcvy2k2xv0f32lw13smz5g72v0yy47zv6vnhnaiaqf3f2d5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libX11 libGL liblo libjack2 ladspaH lv2 rubberband libsndfile fftwFloat libsamplerate ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  makeFlags = [
    "PREFIX=${placeholder ''out''}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.zamaudio.com/?p=976;
    description = "A collection of LV2/LADSPA/VST/JACK audio plugins by ZamAudio";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
