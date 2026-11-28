{
  lib,
  stdenvNoCC,
  makeWrapper,
  playwright-driver,
  testers,
}:
let
  chromium = playwright-driver.components.chromium;

  executablePaths = {
    x86_64-linux = "chrome-linux64/chrome";
    aarch64-linux = "chrome-linux-arm64/chrome";
    aarch64-darwin = "chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing";
  };
  executablePath =
    executablePaths.${stdenvNoCC.hostPlatform.system}
      or (throw "playwright-chromium: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "playwright-chromium";
  version = playwright-driver.browsersJSON.chromium.browserVersion;

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper "${chromium}/${executablePath}" "$out/bin/playwright-chromium"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Chrome for Testing build pinned and patched for Playwright";
    longDescription = ''
      Exposes the Chromium from playwright-driver as a standalone binary.
      Useful for tools that drive Chrome over the DevTools protocol
      (e.g. chrome-devtools-mcp, Puppeteer) on platforms where the chromium
      package isn't available, such as Darwin. Note that its version follows Playwright
      rather than Chrome's stable channel.
    '';
    homepage = "https://developer.chrome.com/blog/chrome-for-testing";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit (playwright-driver.meta) maintainers;
    platforms = lib.attrNames executablePaths;
    mainProgram = "playwright-chromium";
  };
})
