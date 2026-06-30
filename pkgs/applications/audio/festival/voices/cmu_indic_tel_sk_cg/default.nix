{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-tel-sk-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-DuEC6Ak6VJFx9eT/gm6/P56vhOfUMll3fjjK/kxLbuo=";
  };

  passthru.voiceName = "cmu_indic_tel_sk_cg";

  meta = with lib; {
    description = "Festival Telugu voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
