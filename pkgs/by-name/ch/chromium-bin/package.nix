{
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
  testers,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chromium-bin";
  version = "160.0.8162.0";

  __structuredAttrs = true;
  strictDeps = true;

  # https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html
  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac_Arm/1744849/chrome-mac.zip";
    hash = "sha256-wC3BIUsVhmXnHDxAbG2XcMVRUFwwg+K6ehgPNKy74Jo=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  sourceRoot = "chrome-mac";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    mv Chromium.app $out/Applications/

    makeWrapper "$out/Applications/Chromium.app/Contents/MacOS/Chromium" "$out/bin/chromium"

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "chromium --version";
    };
  };

  meta = {
    description = "Open source web browser from Google (binary release)";
    homepage = "https://www.chromium.org/Home/";
    downloadPage = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html";
    license = lib.licenses.bsd3;
    mainProgram = "chromium";
    maintainers = with lib.maintainers; [ a-rustacean ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
