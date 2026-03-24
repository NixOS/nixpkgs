{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  playwright-driver,
  playwright-test,
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    rm -rf "$out/lib/node_modules/@playwright/cli/node_modules/playwright"
    rm -rf "$out/lib/node_modules/@playwright/cli/node_modules/playwright-core"
    ln -s ${playwright-test}/lib/node_modules/playwright "$out/lib/node_modules/@playwright/cli/node_modules/playwright"
    ln -s ${playwright-test}/lib/node_modules/playwright-core "$out/lib/node_modules/@playwright/cli/node_modules/playwright-core"
  '';

  postFixup = ''
    wrapProgram $out/bin/playwright-cli \
      --set-default PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}
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
