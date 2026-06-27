{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-pan-amp-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-8ekjjGuGRqKiUquFX1dzyOvfiz35CeC75Kmde4MKTz4=";
  };

  passthru.voiceName = "cmu_indic_pan_amp_cg";

  meta = with lib; {
    description = "Festival Punjabi voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
