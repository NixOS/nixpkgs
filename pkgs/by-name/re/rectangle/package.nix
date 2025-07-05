{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rectangle";
  version = "0.88";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${finalAttrs.version}/Rectangle${finalAttrs.version}.dmg";
    hash = "sha256-Yyvnu8n+mA+0CX5xbtOs9ZjG99exTT1oj3iGixDotUc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    mv Rectangle.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Intuinewin
      wegank
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
