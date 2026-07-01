{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orbit";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/yuzeguitarist/Orbit/releases/download/v${finalAttrs.version}/Orbit.dmg";
    hash = "sha256-SNwJGUbV6BPmObmMsAui9qXwOPkGheVJ4Ezy6C0Ozpg=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;
  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A radial, gesture-first app switcher and file hub for macOS.";
    homepage = "https://github.com/yuzeguitarist/Orbit";
    changelog = "https://github.com/yuzeguitarist/Orbit/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ myzel394 ];
  };
})
