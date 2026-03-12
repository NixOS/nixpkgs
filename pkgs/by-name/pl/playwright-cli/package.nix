{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  playwright-driver,
}:

buildNpmPackage rec {
  pname = "playwright-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-cli";
    rev = "v${version}";
    hash = "sha256-Ao3phIPinliFDK04u/V3ouuOfwMDVf/qBUpQPESziFQ=";
  };

  npmDepsHash = "sha256-4x3ozVrST6LtLoHl9KtmaOKrkYwCK84fwEREaoNaESc=";

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/playwright-cli \
      --set-default PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}
  '';

  meta = with lib; {
    description = "Playwright CLI for browser automation";
    homepage = "https://github.com/microsoft/playwright-cli";
    changelog = "https://github.com/microsoft/playwright-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ imalison ];
    mainProgram = "playwright-cli";
  };
}
