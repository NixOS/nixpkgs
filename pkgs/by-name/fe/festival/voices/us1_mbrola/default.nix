{
  lib,
  fetchurl,
  buildFestivalVoice,

  # Dependencies
  mbrola-voices,
  mbrola,
}:
buildFestivalVoice (finalAttrs: {
  mbrolaVoiceName = "us1";
  pname = "festvox-us1-mbrola";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.mbrolaVoiceName}.tar.gz";
    hash = "sha256-I7MyUThn1unDQNyIinzmeEPlo8A9syjNNpdZhQV8i44=";
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

  passthru.voiceName = "us1_mbrola";
  passthru.extraBinDeps = [ mbrola ];

  meta = with lib; {
    description = "Festival MBROLA English (US) voice ${finalAttrs.passthru.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
