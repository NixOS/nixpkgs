{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "antigravity-cli";
  inherit (finalAttrs.passthru.sources) version;

  strictDeps = true;
  __structuredAttrs = true;

  src =
    with stdenvNoCC.hostPlatform;
    fetchurl (
      finalAttrs.passthru.sources.platforms.${system}.${libc}
        or (throw "Unsupported platform: ${system} with ${libc}")
    );

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isElf [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 antigravity $out/bin/agy

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    sources = lib.importJSON ./sources.json;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Google's Go-based terminal user interface (TUI) agent client";
    homepage = "https://antigravity.google";
    changelog = "https://antigravity.google/changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      adrielvelazquez
      kirillrdy
      u3kkasha
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources.platforms;
    mainProgram = "agy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
