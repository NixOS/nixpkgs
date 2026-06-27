{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-rab-diphone";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_rablpc16k.tar.gz";
    hash = "sha256-7NFLd8Uo6U37B25EBQEC/o+6V+X+gTrPeKZmKTF/UqU=";
  };

  passthru.voiceName = "rab_diphone";

  meta = with lib; {
    description = "Festival English (GB) voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
