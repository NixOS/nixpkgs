{
  lib,
  fetchurl,
  buildFestivalVoice,
}:

buildFestivalVoice (finalAttrs: {
  pname = "festvox-cmu-us-ahw-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.passthru.voiceName}.tar.gz";
    hash = "sha256-kGSSR4vYa1IB9y/+cBJ5uYs7qUrnSBag1/K6ILwrW/c=";
  };

  passthru.voiceName = "cmu_us_ahw_cg";

  meta = with lib; {
    description = "Festival English (US) voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
