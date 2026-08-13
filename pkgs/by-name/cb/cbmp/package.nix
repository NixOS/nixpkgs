{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbmp";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "cbmp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vOEz2KGJLCiiX+Or9y0JE9UF7sYbwaSCVm5iBv4jIdI=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-9iGfwMyy+cmIp7A5qOderuyL/0wrJ/zCTFPyLL/w3qE=";
  };

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI App for converting cursor svg files to png";
    homepage = "https://github.com/ful1e5/cbmp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mrtnvgr ];
    mainProgram = "cbmp";
  };
})
