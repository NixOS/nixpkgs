{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "reflex-app";
  version = "2.1";

  src = fetchurl {
    url = "https://stuntsoftware.com/download/reflex_${finalAttrs.version}.zip";
    hash = "sha256-wzFkRXjFfjmiuCRMALT9oiWG6NZWQTQqbFZZO3Aoi/w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Reflex.app "$out/Applications"

    runHook postInstall
  '';

  meta = {
    description = "Media key forwarder for Music and Spotify";
    homepage = "https://stuntsoftware.com/reflex/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ wini ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
