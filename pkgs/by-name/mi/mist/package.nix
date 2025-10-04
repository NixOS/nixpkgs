{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mist";
  version = "0.30";

  src = fetchurl {
    url = "https://github.com/ninxsoft/Mist/releases/download/v${finalAttrs.version}/Mist.${finalAttrs.version}.dmg";
    hash = "sha256-J3Oxtw+yFV2Mpzqc6NqPPJR76r0DwywJdAU1FSvbYKE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility that automatically downloads macOS firmwares and installers";
    homepage = "https://github.com/ninxsoft/Mist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ojsef39 ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
