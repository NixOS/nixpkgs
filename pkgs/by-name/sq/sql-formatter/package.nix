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
stdenv.mkDerivation rec {
  pname = "sql-formatter";
  version = "15.6.9";

  src = fetchFromGitHub {
    owner = "sql-formatter-org";
    repo = "sql-formatter";
    rev = "v${version}";
    hash = "sha256-ADyV7rQ54R4QrjLLZy5Pg9KEaW3G5ZY/TssB1Ot/w2o=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
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
}
