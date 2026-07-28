{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-guj-ad-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-SgrC0bFc1BEIvoA+I/EZEb6VO1BzOEio5nQoxkLgK6k=";
  };

  passthru.voiceName = "cmu_indic_guj_ad_cg";

  meta = with lib; {
    description = "Festival Gujarati voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
