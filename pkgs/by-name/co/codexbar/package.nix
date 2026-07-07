{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codexbar";
  version = "0.41.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-macos-universal-${finalAttrs.version}.zip";
    hash = "sha256-M3i05Yu15uTLd/bO5E5bYen3dYo1iTEI/z7+VxeFhY0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

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
  };
})
