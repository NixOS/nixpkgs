{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "appcleaner";
  version = "3.7";

  src = fetchurl {
    url = "https://freemacsoft.net/downloads/AppCleaner_${finalAttrs.version}.zip";
    hash = "sha256-PX+mFG+1falV3KQIWH/GWKwUrrhu2nkHdjrmY5fJ5l4=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Uninstall unwanted apps";
    homepage = "https://freemacsoft.net/appcleaner";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.darwin;
  };
})
