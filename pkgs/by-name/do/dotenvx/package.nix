{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    rev = "refs/tags/v${version}";
    hash = "sha256-AEgf46LCqQCKdq7yEvvumtVVZltPUn8ktLuFiLJar3g=";
  };

  npmDepsHash = "sha256-TdMGkw5/aP9Ki65Ik7286fH5FD5VAfFgATul9ZOHWxA=";

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
