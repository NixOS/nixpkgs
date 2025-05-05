{
  lib,
  stdenvNoCC,
  fetchzip,
  moralerspace,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace-hw";
  inherit (moralerspace) version meta;

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/MoralerspaceHW_v${finalAttrs.version}.zip";
    hash = "sha256-V02Lp7bWKjUGhFJ5fOTVrk74ei0T5UtITQeHZ4OHytw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/moralerspace-hw

    runHook postInstall
  '';

  passthru = {
    inherit (moralerspace) updateScript;
  };
})
