{ stdenv, fetchgit , boost, libX11, libGLU_combined, liblo, libjack2, ladspaH, lv2, pkgconfig, rubberband, libsndfile, fftwFloat, libsamplerate }:

stdenv.mkDerivation rec {
  name = "zam-plugins-${version}";
  version = "3.10";

  src = fetchgit {
    url = "https://github.com/zamaudio/zam-plugins.git";
    deepClone = true;
    rev = "a3321af1892a6994d64fb705e48ae8adf8d7df20";
    sha256 = "0yqrs21ph2lx00p0jlc70qkmzfrnf9ihg1r3i9j5n2r903ljdg5p";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libX11 libGLU_combined liblo libjack2 ladspaH lv2 rubberband libsndfile fftwFloat libsamplerate ];

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
