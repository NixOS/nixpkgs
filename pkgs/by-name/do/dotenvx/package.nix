{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  dotenvx,
}:

buildNpmPackage rec {
  pname = "dotenvx";
  version = "1.39.1";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${version}";
    hash = "sha256-viIW2bQTcfoMhppv96TxD+i85ltGzNrPzZAeYPNcHeI=";
  };

  npmDepsHash = "sha256-SVrsvl2Mw59hsh+RBZV5bZ5Qz5reg1hrDYRYq5y0UIw=";

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
