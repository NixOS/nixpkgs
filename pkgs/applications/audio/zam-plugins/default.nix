{ stdenv, fetchgit , boost, libX11, libGL, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile, fftwFloat, libsamplerate }:

stdenv.mkDerivation {
  pname = "zam-plugins";
  version = "3.12";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "87fdee6e87dbee75c1088e2327ea59c1ab1522e4";
    sha256 = "0kz0xygff3ca1v9nqi0dvrzy9whbzqxrls5b7hydi808d795893n";
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
