{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "dotenvx";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lFAnH1BcVRTvFyP5gOteNfokU0zYaoIY45df9fQ9cuA=";
  };

  npmDepsHash = "sha256-7EvZ3QOAiu2GPvDbHVfrbaF/0lAscH9lfsukv4WtBK0=";

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
