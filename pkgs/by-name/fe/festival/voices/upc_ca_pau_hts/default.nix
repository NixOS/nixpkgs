{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
}:

buildFestivalVoice (finalAttrs: {
  pname = "upc-ca-pau-hts";
  version = "1.3";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.passthru.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-4ihO0E4iVb0mBCon5oySAcaHFseDPqWwQ21RYIFdutY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.passthru.voiceName}"
    for d in festvox hts; do
      [ -d "$d" ] && cp -r "$d" "$out/lib/voices/catalan/${finalAttrs.passthru.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.voiceName = "upc_ca_pau_hts";
  passthru.extraLibDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice ${finalAttrs.passthru.voiceName}";
    homepage = "https://festcat.talp.cat";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
