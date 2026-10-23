{
  lib,
  stdenvNoCC,
  _7zz,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lunar";
  version = "6.11.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/alin23/Lunar/releases/download/v${finalAttrs.version}/Lunar-${finalAttrs.version}.dmg";
    hash = "sha256-pFrT5LBqRynqyMdXFP5DBn69THUNnXKbJ4l96DHxI30=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./Lunar.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Defacto app for controlling monitors";
    homepage = "https://lunar.fyi/";
    changelog = "https://github.com/alin23/Lunar/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      unfree
    ];
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
