{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-tam-sdr-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-mkwIjOO9vxeGfV35GPw4aFlwYTgK6Nr4ls6Z0zcj5XA=";
  };

  passthru.voiceName = "cmu_indic_tam_sdr_cg";

  meta = with lib; {
    description = "Festival Tamil voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
