{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    rev = "refs/tags/v${version}";
    hash = "sha256-A7RojzdBwJ06JHBAoxVmOi9cAxoeGTwAK08jmST7pls=";
  };

  npmDepsHash = "sha256-KToJAeWsCeJ2GO/k5UuOa/7oOYjNsS0kMt0o+yDyppM=";

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
