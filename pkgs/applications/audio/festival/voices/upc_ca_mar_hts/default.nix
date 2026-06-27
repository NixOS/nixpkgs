{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
}:

buildFestivalVoice (finalAttrs: {
  pname = "upc-ca-mar-hts";
  version = "1.3";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.passthru.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-3xniwqKiOH60rXs7qovcQS9trDjTA4YP5l6BzriQ+TY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.passthru.voiceName}"
    for d in festvox hts; do
      [ -d "$d" ] && cp -r "$d" "$out/lib/voices/catalan/${finalAttrs.passthru.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.voiceName = "upc_ca_mar_hts";
  passthru.extraLibDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice ${finalAttrs.passthru.voiceName}";
    homepage = "https://festcat.talp.cat";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
