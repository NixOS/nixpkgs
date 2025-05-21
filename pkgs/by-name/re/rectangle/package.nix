{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rectangle";
  version = "0.87";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${finalAttrs.version}/Rectangle${finalAttrs.version}.dmg";
    hash = "sha256-onXzRRUvr3WiVn9JZxVLqXFcCmFG/u1n+oOsTEQMi+8=";
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
