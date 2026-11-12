{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "dotenvx";
  version = "2.38.2";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GzRkB2jFV1s43YTqf5KDglsMfu/nrCwZnrTw5xMOnwM=";
  };

  npmDepsHash = "sha256-X0DyVHfcJCSvaCMW5+bXMiv73muzyHmy9/yUKpAfKP8=";

  dontNpmBuild = true;

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      # access to the home directory
      command = "HOME=$TMPDIR dotenvx --version";
    };
  };

  meta = {
    description = "Better dotenv–from the creator of `dotenv`";
    homepage = "https://github.com/dotenvx/dotenvx";
    changelog = "https://github.com/dotenvx/dotenvx/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      natsukium
      kaynetik
    ];
    mainProgram = "dotenvx";
  };
})
