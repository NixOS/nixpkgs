{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-guj-kt-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-ZmAX2NZHN8T9cLcqts+Eb9jhPeKQpbpJS9Fpckmhbp0=";
  };

  passthru.voiceName = "cmu_indic_guj_kt_cg";

  meta = with lib; {
    description = "Festival Gujarati voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
