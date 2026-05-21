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
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "google-lighthouse";
  version = "13.3.0";

  src = fetchFromGitHub {
    owner = "GoogleChrome";
    repo = "lighthouse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GFaM6R836Z/EKTvDLF0/aLox5VltcwgLSWzAmn77EY=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-tzN0rAHahBs4n6KCCAS2xoCxXmaZVtmB4WSNxia9TME=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automated auditing, performance metrics, and best practices for the web";
    homepage = "https://developer.chrome.com/docs/lighthouse/overview";
    license = lib.licenses.asl20;
    mainProgram = "lighthouse";
    maintainers = with lib.maintainers; [ theCapypara ];
  };
})
