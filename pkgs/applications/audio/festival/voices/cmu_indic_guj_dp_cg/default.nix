{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-guj-dp-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-Gk4X1n21Cm2B94YLZKzI1BJF9vdjzP9Mk4armumSORA=";
  };

  passthru.voiceName = "cmu_indic_guj_dp_cg";

  meta = with lib; {
    description = "Festival Gujarati voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
