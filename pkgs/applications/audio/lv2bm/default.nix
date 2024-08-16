{ lib, stdenv, fetchFromGitHub, glib, libsndfile, lilv, lv2, pkg-config, serd, sord, sratom }:

stdenv.mkDerivation rec {
  pname = "lv2bm";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "moddevices";
    repo = "lv2bm";
    rev = "v${version}";
    sha256 = "0vlppxfb9zbmffazs1kiyb79py66s8x9hihj36m2vz86zsq7ybl0";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libsndfile lilv lv2 serd sord sratom ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    homepage = "https://github.com/portalmod/lv2bm";
    description = "Benchmark tool for LV2 plugins";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "lv2bm";
  };
}
