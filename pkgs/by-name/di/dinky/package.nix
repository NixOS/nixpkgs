{
  fetchzip,
  gitUpdater,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dinky";
  version = "0.23";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/mikker/Dinky/releases/download/v${finalAttrs.version}/dinky.app.zip";
    stripRoot = false;
    hash = "sha256-/xhc/4jk5mPrNsgwS+qG4Q68EvAaiv6BujvUYIDpSXM=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R dinky.app $out/Applications/
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/mikker/Dinky.git";
    rev-prefix = "v";
  };

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/mikker/Dinky";
    description = "tiling wm for macOS. No honey, we have hyprland at home";
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mkapra ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
