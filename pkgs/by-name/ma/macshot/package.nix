{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "macshot";
  version = "4.1.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/sw33tLie/macshot/releases/download/v${finalAttrs.version}/MacShot.dmg";
    hash = "sha256-5o8l6MvGs58zSPKaR4RQZ2UgWsqcQRaRUsd8cS62VVg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    undmg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R macshot.app "$out/Applications/"

    mkdir -p "$out/bin"
    ln -s "$out/Applications/macshot.app/Contents/MacOS/macshot" "$out/bin/macshot"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-packed native macOS screenshot & recording tool";
    homepage = "https://github.com/sw33tLie/macshot";
    changelog = "https://github.com/sw33tLie/macshot/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "macshot";
    platforms = lib.platforms.darwin;
  };
})
