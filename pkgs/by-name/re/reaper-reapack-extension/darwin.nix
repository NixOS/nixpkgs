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
    url = "https://codeberg.org/cfillion/reapack/releases/download/v${finalAttrs.version}/reaper_reapack-arm64.dylib";
    hash = "sha256-x2cPOy5AW5A31JsZQaTYw3Yv/zJs7MDFisT67KFx8Hs=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D * -t $out/UserPlugins
    runHook postInstall
  '';
})
