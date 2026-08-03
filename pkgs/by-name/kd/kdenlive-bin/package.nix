{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  undmg,
  kdePackages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kdenlive-bin";
  version = "26.04.3";

  src = fetchurl {
    url = "mirror://kde/stable/kdenlive/${lib.versions.majorMinor finalAttrs.version}/macOS/kdenlive-${finalAttrs.version}-arm64.dmg";
    hash = "sha256-6oLNi4F4lFXJh9n7DUerR/6UlaYyuy1JXDGyfhmZKAI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  sourceRoot = ".";

  nativeBuildInputs = [
    makeBinaryWrapper
    undmg
  ];

  # Make sure to not break dmg code signature
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R kdenlive.app $out/Applications/

    makeWrapper $out/Applications/kdenlive.app/Contents/MacOS/kdenlive $out/bin/kdenlive
    makeWrapper $out/Applications/kdenlive.app/Contents/MacOS/kdenlive_render $out/bin/kdenlive_render

    runHook postInstall
  '';

  passthru.updateScript = ./update.py;

  meta = {
    inherit (kdePackages.kdenlive.meta) description license;
    homepage = "https://kdenlive.org";
    downloadPage = "https://kdenlive.org/en/download/";
    changelog = "https://kdenlive.org/en/releases/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ BatteredBunny ];
    mainProgram = "kdenlive";
    platforms = lib.platforms.darwin;
  };
})
