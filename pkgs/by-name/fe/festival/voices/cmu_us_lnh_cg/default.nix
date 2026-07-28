{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-us-lnh-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-7OgfQjef66TDkq1yP7aDdK/5zXj1fPYp9iSwvQySjQg=";
  };

  passthru.voiceName = "cmu_us_lnh_cg";

  meta = with lib; {
    description = "Festival English (US) voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
