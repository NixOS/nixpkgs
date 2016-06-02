{ stdenv, fetchgit, cairomm, cmake, libjack2, libpthreadstubs, libXdmcp, libxshmfence, libsndfile, lv2, ntk, pkgconfig }:

stdenv.mkDerivation rec {
  name = "artyFX-git-${version}";
  version = "2015-05-07";

  src = fetchgit {
    url = "https://github.com/harryhaaren/openAV-ArtyFX.git";
    rev = "3a8cb9a5e4ffaf27a497a31cc9cd6f2e79622d5b";
    sha256 = "0nsmycm64a686ysfnmdvnaazijvfj90z5wyp96kyr81nsrbcv2ij";
  };

  buildInputs = [ cairomm cmake libjack2 libpthreadstubs libXdmcp libxshmfence libsndfile lv2 ntk pkgconfig   ];

  meta = with stdenv.lib; {
    homepage = http://openavproductions.com/artyfx/;
    description = "A LV2 plugin bundle of artistic realtime effects";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
