{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.45.1";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${version}";
    hash = "sha256-qNKRFgZWfIoLwYzB+1fCKR8FOesZEci3bPf/o081wig=";
  };

  npmDepsHash = "sha256-qrtVQGbxcyxypyyV2IFcdHs4msJqXBhxISEELR812AA=";

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
