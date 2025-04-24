{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sof-firmware";
  version = "2025.01.1";

  src = fetchurl {
    url = "https://github.com/thesofproject/sof-bin/releases/download/v${finalAttrs.version}/sof-bin-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-o2IQ2cJF6BsNlnTWsn0f1BIpaM+SWu/FW0htNlD4gyM=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware/intel
    cp -av sof $out/lib/firmware/intel/sof
    cp -av sof-tplg $out/lib/firmware/intel/sof-tplg
    cp -av sof-ace-tplg $out/lib/firmware/intel/sof-ace-tplg
    cp -av sof-ipc4 $out/lib/firmware/intel/sof-ipc4
    cp -av sof-ipc4-tplg $out/lib/firmware/intel/sof-ipc4-tplg
    cp -av sof-ipc4-lib $out/lib/firmware/intel/sof-ipc4-lib
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/thesofproject/sof-bin/releases/tag/v${finalAttrs.version}";
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with lib.licenses; [
      bsd3
      isc
    ];
    maintainers = with lib.maintainers; [
      lblasc
      evenbrenden
      hmenke
    ];
    platforms = with lib.platforms; linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
