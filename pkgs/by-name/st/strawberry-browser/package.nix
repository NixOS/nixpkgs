{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "strawberry-browser";
  version = "0.1.11";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://strawberrybucket.com/strawberry-${finalAttrs.version}.dmg";
    hash = "sha256-OwwBwJXfhPqPgF0TrZaxaju6+Mc4NygfzfEkSfh19qg=";
  };

  sourceRoot = "Strawberry.app";

  nativeBuildInputs = [ undmg ];

  # prebuilt, Developer ID signed, hardened-runtime bundle; leave it untouched so
  # the signature stays valid
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Strawberry.app"
    cp -R . "$out/Applications/Strawberry.app"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "AI-powered web browser";
    homepage = "https://strawberrybrowser.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ vmfunc ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ]; # unfree, prebuilt: nothing for Hydra to build
  };
})
