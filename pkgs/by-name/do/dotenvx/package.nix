{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.44.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${version}";
    hash = "sha256-8YYCDcwXBURd/9ZDxCxqUwJzRXQERd9MrwGaqi5XjV0=";
  };

  npmDepsHash = "sha256-h2tRViwPyicFVUth6C6XA3ze5SnI0oJgYJkshqi18WQ=";

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
