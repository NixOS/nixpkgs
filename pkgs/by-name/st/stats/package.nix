{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.11.62";

  src = fetchurl {
    url = "https://github.com/exelban/stats/releases/download/v${finalAttrs.version}/Stats.dmg";
    hash = "sha256-23xTP1NbJ43eWISELAUu7aZuIW2cr5O8jV2nRppi9Yw=";
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
    changelog = "https://github.com/exelban/stats/releases/tag/v${finalAttrs.version}";
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      FlameFlag
      emilytrau
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
