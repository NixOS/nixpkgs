{ stdenv, fetchFromGitHub , cairomm, cmake, libjack2, libpthreadstubs, libXdmcp, libxshmfence, libsndfile, lv2, ntk, pkgconfig }:

stdenv.mkDerivation rec {
  name = "artyFX-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-ArtyFX";
    rev = "release-${version}";
    sha256 = "012hcy1mxl7gs2lipfcqp5x0xv1azb9hjrwf0h59yyxnzx96h7c9";
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
