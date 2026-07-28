{
  lib,
  fetchurl,
  buildFestivalVoice,

  # Dependencies
  mbrola-voices,
  mbrola,
}:
buildFestivalVoice (finalAttrs: {
  mbrolaVoiceName = "en1";
  pname = "festvox-en1-mbrola";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.mbrolaVoiceName}.tar.gz";
    hash = "sha256-pLtV056u8x62rYuRUDXDEQiyQnEIUS4cMBlB+/j2/7k=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r lib "$out/lib"

    ln -s "${
      mbrola-voices.override { languages = [ finalAttrs.mbrolaVoiceName ]; }
    }/data/${finalAttrs.mbrolaVoiceName}"         "$out/lib/voices/english/${finalAttrs.passthru.voiceName}/${finalAttrs.mbrolaVoiceName}"

    runHook postInstall
  '';

  passthru.voiceName = "en1_mbrola";
  passthru.extraBinDeps = [ mbrola ];

  meta = with lib; {
    description = "Festival MBROLA English (GB) voice ${finalAttrs.passthru.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
