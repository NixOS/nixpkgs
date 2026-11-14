{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeBinaryWrapper,
  versionCheckHook,
  writeShellScript,
  xcbuild,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-desktop";
  version = "1.20186.1";
  release = "df1d8a339dfabcf359af7144fe142b59ff7d9a0f";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://downloads.claude.ai/releases/darwin/universal/${finalAttrs.version}/Claude-${finalAttrs.release}.zip";
    hash = "sha256-JQYp6pXMlcDbRpYqwzCVw/ILGndqquTfeqUflhceeGY=";
  };

  dontUnpack = true;
  # Keep upstream app bundle as-is.
  dontFixup = true;
  strictDeps = true;

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    unzip -q "$src"

    mkdir -p "$out/Applications"
    cp -R "Claude.app" "$out/Applications/Claude.app"

    # Nix-managed installs are immutable, so disable the app's self-updater.
    makeBinaryWrapper "$out/Applications/Claude.app/Contents/MacOS/Claude" "$out/bin/claude-desktop" \
      --set DISABLE_AUTOUPDATER 1

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    ${xcbuild}/bin/PlistBuddy -c "Print :CFBundleShortVersionString" "$1"
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/Claude.app/Contents/Info.plist" ];
  doInstallCheck = true;

  meta = {
    description = "Anthropic's official Claude AI desktop app";
    homepage = "https://claude.com/download";
    downloadPage = "https://claude.com/download";
    changelog = "https://downloads.claude.ai/releases/darwin/universal/RELEASES.json";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ IanHollow ];
    platforms = lib.platforms.darwin;
    mainProgram = "claude-desktop";
  };
})
