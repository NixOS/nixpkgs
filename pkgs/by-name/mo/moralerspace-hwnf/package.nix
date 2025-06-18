{
  lib,
  stdenvNoCC,
  fetchzip,
  moralerspace,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moralerspace-hwnf";
  inherit (moralerspace) version meta;

  src = fetchzip {
    url = "https://github.com/yuru7/moralerspace/releases/download/v${finalAttrs.version}/MoralerspaceHWNF_v${finalAttrs.version}.zip";
    hash = "sha256-XRdDcfgwbP5g26xh9rlHRp9i//k5PdRhMExMy3ibN/4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/moralerspace-hwnf

    runHook postInstall
  '';

  passthru = {
    inherit (moralerspace) updateScript;
  };
})
