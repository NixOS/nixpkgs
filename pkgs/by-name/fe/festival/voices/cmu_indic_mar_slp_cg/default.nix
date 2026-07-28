{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-mar-slp-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-875yQdNdseGNZS4s+ky2m64DjD0hxZ7TzjZUh4lPDUY=";
  };

  passthru.voiceName = "cmu_indic_mar_slp_cg";

  meta = with lib; {
    description = "Festival Marathi voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
