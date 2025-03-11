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
    hash = "sha256-rYDx3MMjxnmp/o6nRc5/bIEkwvMP9gmwm6R//3KwoLk=";
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
