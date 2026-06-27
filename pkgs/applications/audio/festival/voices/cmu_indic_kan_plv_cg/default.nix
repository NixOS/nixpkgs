{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-kan-plv-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-2H9Oo0LnyzfpDd9J3eN/GcFHCzxaCdAM7zISEIEHyzE=";
  };

  passthru.voiceName = "cmu_indic_kan_plv_cg";

  meta = with lib; {
    description = "Festival Kannada voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
