{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    rev = "refs/tags/v${version}";
    hash = "sha256-i6181Ot40t2IlAGpj0pES9nPFB1dZrcypgs4qLQ05hE=";
  };

  npmDepsHash = "sha256-wo+Gtq2gdcIWY0yDzf5vrxEHfFzMfpgIjG+/MBdvz1U=";

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
