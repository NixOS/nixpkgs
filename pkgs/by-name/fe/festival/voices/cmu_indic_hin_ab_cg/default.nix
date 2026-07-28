{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-indic-hin-ab-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-YDGOFg2ZTVF0FozJRGfHdt6BQm+RxPgAMgbP+VPLeb0=";
  };

  passthru.voiceName = "cmu_indic_hin_ab_cg";

  meta = with lib; {
    description = "Festival Hindi voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
