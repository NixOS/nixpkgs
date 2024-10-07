{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    rev = "refs/tags/v${version}";
    hash = "sha256-SlZ18ToGbC+c5ffuYFGeOy30w90ukBO0qKxD+HNVt3E=";
  };

  npmDepsHash = "sha256-KaqSCtraMmQHe7Tcs/2CVaQcmazgHkV5K4T64lHEVP4=";

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
