{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
}:

buildFestivalVoice (finalAttrs: {
  pname = "upc-ca-pau-clunits";
  version = "1.2";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.passthru.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-su48FUQdcNN3Kr4G6T7y4RWoJVz7pd7czHTWxi4VFnQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.passthru.voiceName}"
    for d in doc festival festvox mcep wav; do
      [ -d "$d" ] && cp -r "$d" "$out/lib/voices/catalan/${finalAttrs.passthru.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.voiceName = "upc_ca_pau_clunits";
  passthru.extraLibDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice ${finalAttrs.passthru.voiceName}";
    homepage = "https://festcat.talp.cat";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
