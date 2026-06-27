{
  lib,
  fetchurl,
  buildFestivalVoice,

  # Dependencies
  mbrola-voices,
  mbrola,
  festival-czech,
}:
buildFestivalVoice (finalAttrs: {
  mbrolaVoiceName = "cz2";
  pname = "festival-cz2";
  version = "${mbrola-voices.version}";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp ${festival-czech}/lib/czech-mbrola.scm $out/lib/czech-mbrola.scm

    substituteInPlace $out/lib/czech-mbrola.scm       --replace-fail         '(defvar czech-mbrola_database nil)'         "(defvar czech-mbrola_database \"${
            mbrola-voices.override { languages = [ ''cz2'' ]; }
        }/data/cz2/cz2\")"

    mkdir -p "$out/lib/voices/czech/czech_mbrola_cz2/festvox"
    cat > "$out/lib/voices/czech/czech_mbrola_cz2/festvox/czech_mbrola_cz2.scm" << 'VOICESCM'
(proclaim_voice
 '${finalAttrs.passthru.voiceName}
 '((language czech)
   (gender male)
   (description "Czech voice provided by the Mbrola cz2 database.")))
VOICESCM

    runHook postInstall
  '';

  passthru.voiceName = "czech_mbrola_cz2";
  passthru.extraBinDeps = [ mbrola ];
  passthru.extraLibDeps = [ festival-czech ];
  passthru.siteInit = "(require 'czech-mbrola)";

  meta = with lib; {
    description = "Festival MBROLA Czech voice ${finalAttrs.passthru.voiceName}";
    license = licenses.mit;
    maintainers = with maintainers; [ WiredMic ];
  };
})
