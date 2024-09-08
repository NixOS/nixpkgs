{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  nix-update-script
}: mkYarnPackage rec {
  pname = "gramma";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "caderek";
    repo = "gramma";
    rev = "v${version}";
    hash = "sha256-gfBwKpsttdhjD/Opn8251qskURpwLX2S5NSbpwP3hFg=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-FuR6wUhAaej/vMgjAlICMEj1pPf+7PFrdu2lTFshIkg=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "command-line grammar checker";
    homepage = "https://caderek.github.io/gramma/";
    changelog = "https://github.com/caderek/gramma/releases/tag/v${version}";
    license = lib.licenses.isc;
    mainProgram = "gramma";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
