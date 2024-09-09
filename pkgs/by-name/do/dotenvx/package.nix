{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    rev = "refs/tags/v${version}";
    hash = "sha256-j30ZEYO8OBMhEPn+LDipZ/aciWrI9QWStz6tHq0uX7E=";
  };

  npmDepsHash = "sha256-ZSnrV1C9NX/Wq7cjKlM1w/m6T7snfnPru5g0pqFTGis=";

  dontNpmBuild = true;

  passthru.tests = {
    version = testers.testVersion {
      package = dotenvx;
      # access to the home directory
      command = "HOME=$TMPDIR dotenvx --version";
    };
  };

  meta = {
    description = "Better dotenv–from the creator of `dotenv";
    homepage = "https://github.com/dotenvx/dotenvx";
    changelog = "https://github.com/dotenvx/dotenvx/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "dotenvx";
  };
}
