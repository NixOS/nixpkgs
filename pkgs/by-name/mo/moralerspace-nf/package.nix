{
  lib,
  stdenvNoCC,
  fetchzip,
  moralerspace,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace-nf";
  inherit (moralerspace) version meta;

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/MoralerspaceNF_v${finalAttrs.version}.zip";
    hash = "sha256-zpJ6I/4WMiVfDbowcvw1JAup0RdvylJCzQbwa5qWM44=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/moralerspace-nf

    runHook postInstall
  '';

  passthru = {
    inherit (moralerspace) updateScript;
  };
})
