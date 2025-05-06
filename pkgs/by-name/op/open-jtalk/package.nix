{
  lib,
  stdenv,
  fetchurl,
  hts-engine,
  hts-voice-nitech-jp-atr503-m001,
}:

stdenv.mkDerivation rec {
  pname = "open-jtalk";
  version = "1.11";

  src = fetchurl {
    url = "mirror://sourceforge/open-jtalk/Open%20JTalk/open_jtalk-${version}/open_jtalk-${version}.tar.gz";
    sha256 = "sha256-IP3GrrbHV4ZgNKvBdYIFc9tD5ChHB8hm/NAsjsGN5x8=";
  };

  # set defaults for dictionary and voice files
  patches = [
    ./dic-path.patch
    ./voice-path.patch
  ];
  voice = "${hts-voice-nitech-jp-atr503-m001}/share/hts-voice/nitech_jp_atr503_m001.htsvoice";
  postPatch = ''
    substituteAllInPlace bin/open_jtalk.c
  '';

  buildInputs = [ hts-engine ];

  configureFlags = [
    "--with-hts-engine-header-path=${hts-engine}/include"
    "--with-hts-engine-library-path=${hts-engine}/lib"
  ];

  meta = with lib; {
    description = "Japanese text-to-speech synthesis system";
    homepage = "https://open-jtalk.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yorwba ];
  };
}
