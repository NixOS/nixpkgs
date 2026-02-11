{
  lib,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sql-formatter";
  version = "15.7.0";

  src = fetchFromGitHub {
    owner = "sql-formatter-org";
    repo = "sql-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k105xoppmxW1jSbkzbqHF7bg/IbY1P9kZVwa3pdKF7k=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-zcCYGTuaPkizZHc4K6RAPWwMnP5LtnyaLbF9xcPpNBs=";
  };

  nativeBuildInputs = [
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Whitespace formatter for different query languages";
    homepage = "https://sql-formatter-org.github.io/sql-formatter";
    license = lib.licenses.mit;
    mainProgram = "sql-formatter";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
