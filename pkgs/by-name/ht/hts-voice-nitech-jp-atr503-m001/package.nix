{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "hts-voice-nitech-jp-atr503-m001";
  version = "1.05";

  src = fetchurl {
    url = "mirror://sourceforge/open-jtalk/HTS%20voice/hts_voice_nitech_jp_atr503_m001-${version}/hts_voice_nitech_jp_atr503_m001-${version}.tar.gz";
    sha256 = "sha256-LlVciEgiZ7KTHH28fswOPfFA1vaPyROqSCLzNsngrfw=";
  };

  installPhase = ''
    mkdir -p $out/share/hts-voice
    cp nitech_jp_atr503_m001.htsvoice $out/share/hts-voice/
  '';

  meta = with lib; {
    description = "Japanese male voice data for Open JTalk";
    homepage = "https://open-jtalk.sourceforge.net/";
    license = licenses.cc-by-30;
    maintainers = with maintainers; [ yorwba ];
  };
}
