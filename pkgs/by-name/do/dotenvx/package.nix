{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.48.1";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${version}";
    hash = "sha256-3iS0Pm1+MDSDl5v0oknJVoBbTNHV1xoanclA+94/1vI=";
  };

  npmDepsHash = "sha256-fFip2WJYaOtwzYe85acFbwnzfgvlLv7hw+4eHhK37I4=";

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
