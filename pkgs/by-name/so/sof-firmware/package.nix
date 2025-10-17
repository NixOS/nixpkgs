{
  lib,
  fetchurl,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sof-firmware";
  version = "2025.05.1";

  src = fetchurl {
    url = "https://github.com/thesofproject/sof-bin/releases/download/v${finalAttrs.version}/sof-bin-${finalAttrs.version}.tar.gz";
    hash = "sha256-YNVOrjJpQzKiEgt8ROSvQDoU/h/fTFjXKYEQKxkdJZw=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/intel
    # copy sof and sof-* recursively, preserving symlinks
    cp -R -d sof{,-*} $out/lib/firmware/intel/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

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
