{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "sound-icons";
  version = "0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://freebsoft.org/pub/projects/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-OC3aHRSgezElqLUIRpWqm6XLD/8C5aq2n9bH4jy89Nc=";
  };

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sounds/sound-icons
    cp -r * $out/share/sounds/sound-icons

    runHook postInstall
  '';

  meta = {
    description = "Sound icons are a set of wave file used by eSpeak developed for Free(b)soft";
    homepage = "https://freebsoft.org/index";
    license = with lib.licenses; [
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ WiredMic ];
  };
})
