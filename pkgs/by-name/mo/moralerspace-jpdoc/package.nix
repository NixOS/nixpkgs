{
  lib,
  stdenvNoCC,
  fetchzip,
  moralerspace,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace-jpdoc";
  inherit (moralerspace) version meta;

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/MoralerspaceJPDOC_v${finalAttrs.version}.zip";
    hash = "sha256-FDiWiqIAFoiA1SFCv7ff5kCfPcKTbSxxGBWHOljQYVg=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/moralerspace-jpdoc

    runHook postInstall
  '';

  passthru = {
    inherit (moralerspace) updateScript;
  };
})
