{
  stdenv,
  lib,
  chromium, # Can be overwritten to be (potentially) any Chromium implementation
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "google-lighthouse";
  version = "12.5.1";

  src = fetchFromGitHub {
    owner = "GoogleChrome";
    repo = "lighthouse";
    tag = "v${version}";
    hash = "sha256-v4V4K77WC3InQ+jRlzw0JV8ehPF+hwWlnAt3P8yHMGU=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-qdOR7A8ku8qJyJ3rdzH1okt+P1aekGfdtZbxjYOqehA=";
  };

  yarnBuildScript = "build-report";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    chromium
    nodejs
  ];

  postCheck = ''
    yarn unit
    yarn test-clients
    yarn test-docs
    yarn test-treemap
  '';

  postInstall = ''
    wrapProgram "$out/bin/lighthouse" \
      --set CHROME_PATH ${lib.getExe chromium}
  '';

  doDist = false;
  meta = {
    description = "Automated auditing, performance metrics, and best practices for the web";
    homepage = "https://developer.chrome.com/docs/lighthouse/overview";
    license = lib.licenses.asl20;
    mainProgram = "lighthouse";
    maintainers = with lib.maintainers; [ theCapypara ];
  };
}
