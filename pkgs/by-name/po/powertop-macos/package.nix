{
  fetchurl,
  lib,
  makeWrapper,
  nix-update-script,
  rcodesign,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "powertop-macos";
  version = "1.3.7";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/kDolphin/PowerTop/releases/download/v${finalAttrs.version}/PowerTop.zip";
    hash = "sha256-rwzwCIwyXI9RKSFC4OaNGJZS16zeaw1WpY8ntctDssQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    rcodesign
    unzip
  ];

  dontConfigure = true;
  dontBuild = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    app="$out/Applications/PowerTop.app"
    mkdir -p "$out/Applications"
    cp -R PowerTop.app "$app"

    makeWrapper "$app/Contents/MacOS/PowerTop" "$out/bin/powertop-macos"

    runHook postInstall
  '';

  postFixup = ''
    ${lib.getExe rcodesign} sign "$out/Applications/PowerTop.app"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    changelog = "https://github.com/kDolphin/PowerTop/releases/tag/v${finalAttrs.version}";
    description = "Menu bar app for monitoring MacBook power usage";
    homepage = "https://github.com/kDolphin/PowerTop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mnixry ];
    mainProgram = "powertop-macos";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
