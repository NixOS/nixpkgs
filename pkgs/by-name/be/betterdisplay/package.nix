{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "betterdisplay";
  version = "3.2.1";

  src = fetchurl {
    url = "https://github.com/waydabber/BetterDisplay/releases/download/v${finalAttrs.version}/BetterDisplay-v${finalAttrs.version}.dmg";
    hash = "sha256-UQLVRCeUznTqT6qDR6sZRZ5xMVgs0Th2iRRpnF0pqVI=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  buildInputs = [ undmg ];

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv BetterDisplay.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unlock your displays on your Mac! Flexible HiDPI scaling, XDR/HDR extra brightness, virtual screens, DDC control, extra dimming, PIP/streaming, EDID override and lots more";
    homepage = "https://betterdisplay.pro/";
    changelog = "https://github.com/waydabber/BetterDisplay/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
  };
})
