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
  version = "15.4.3";

  src = fetchFromGitHub {
    owner = "sql-formatter-org";
    repo = "sql-formatter";
    rev = "v${version}";
    hash = "sha256-FMzNf++PXV136yetXlYJIXkP/i2iWLrcmar5/6NrXJk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-R3PDDWxNtPK18adtHB4Jjp451Mp2p+5Fw6A1xkC58oY=";
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
