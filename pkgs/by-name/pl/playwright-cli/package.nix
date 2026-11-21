{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  playwright-driver,
}:

buildNpmPackage (finalAttrs: {
  pname = "playwright-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ao3phIPinliFDK04u/V3ouuOfwMDVf/qBUpQPESziFQ=";
  };

  npmDepsHash = "sha256-4x3ozVrST6LtLoHl9KtmaOKrkYwCK84fwEREaoNaESc=";

  dontNpmBuild = true;

  # playwright-cli imports playwright/lib/cli/client/program, which current
  # nixpkgs playwright-test does not export, so keep the vendored Playwright
  # until nixpkgs Playwright is updated to a compatible version.
  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram $out/bin/playwright-cli \
      --set-default PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}
  '';

  doInstallCheck = true;
  # versionCheckHook is not usable here: `playwright-cli --version` reports the
  # bundled Playwright version (e.g. "1.59.0-alpha-1771104257000"), not this
  # package's version, so it can never match finalAttrs.version. Assert instead
  # that the wrapped CLI actually starts and reports a plausible version.
  installCheckPhase = ''
    runHook preInstallCheck

    versionOutput=$($out/bin/playwright-cli --version)
    echo "playwright-cli --version: $versionOutput"
    if ! grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+' <<<"$versionOutput"; then
      echo "unexpected 'playwright-cli --version' output" >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "Playwright CLI for browser automation";
    homepage = "https://github.com/microsoft/playwright-cli";
    changelog = "https://github.com/microsoft/playwright-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "playwright-cli";
  };
})
