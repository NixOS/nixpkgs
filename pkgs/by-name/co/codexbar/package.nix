{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  makeWrapper,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codexbar";
  version = "0.43.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-macos-universal-${finalAttrs.version}.zip";
    hash = "sha256-dKr5/7HzgqDXUwkHGj1z534ekTajyUFNSrpg+vK/4Yw=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r CodexBar.app $out/Applications
    makeWrapper $out/Applications/CodexBar.app/Contents/MacOS/CodexBar $out/bin/codexbar

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://github.com/steipete/CodexBar" ];
  };

  meta = {
    description = "Show usage stats for AI coding-provider limits";
    homepage = "https://codex.bar/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      kinnrai
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "codexbar";
  };
})
