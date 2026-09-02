{
  stdenvNoCC,
  fetchurl,
  pname,
  version,
  meta,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    meta
    ;
  src = fetchurl {
    url = "https://github.com/cfillion/reapack/releases/download/v${finalAttrs.version}/reaper_reapack-arm64.dylib";
    hash = "sha256-eFKEUuTUWE4Wp/vWVrvTbK78U6TicvRXSWggVAH2Og4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D * -t $out/UserPlugins
    runHook postInstall
  '';
})
