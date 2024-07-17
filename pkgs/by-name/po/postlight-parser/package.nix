{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  npmHooks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postlight-parser";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "postlight";
    repo = "parser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k6m95FHeJ+iiWSeY++1zds/bo1RtNXbnv2spaY/M+L0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-Vs8bfkhEbPv33ew//HBeDnpQcyWveByHi1gUsdl2CNI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    npmHooks.npmInstallHook
  ];
  # Upstream doesn't include a script in package.json that only builds without
  # testing, and tests fail because they need to access online websites. Hence
  # we use the builtin interface of yarnBuildHook to lint, and in `postBuild`
  # we run the rest of commands needed to create the js files eventually
  # distributed and wrapped by npmHooks.npmInstallHook
  yarnBuildScript = "lint";
  postBuild = ''
    yarn --offline run rollup -c
  '';
  # Tries to download stuff from the internet in this phase.
  dontNpmPrune = true;

  meta = {
    changelog = "https://github.com/postlight/parser/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    homepage = "https://reader.postlight.com";
    description = "Extracts the bits that humans care about from any URL you give it";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "postlight-parser";
  };
})
