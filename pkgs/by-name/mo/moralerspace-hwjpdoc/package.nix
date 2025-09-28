{
  lib,
  stdenvNoCC,
  fetchzip,
  moralerspace,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace-hwjpdoc";
  inherit (moralerspace) version meta;

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/MoralerspaceHWJPDOC_v${finalAttrs.version}.zip";
    hash = "sha256-t8dp+SwndHxBA5YE2TYTWP6x3MgczbMXQ6oNvMD0ycU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/moralerspace-hwjpdoc

    runHook postInstall
  '';

  passthru = {
    inherit (moralerspace) updateScript;
  };
})
