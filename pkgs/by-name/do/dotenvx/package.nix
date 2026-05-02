{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "dotenvx";
  version = "1.64.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xa3xtDzvSbgba083R2g3vV8Jtv86NMEbZ/EhYxmGsKA=";
  };

  npmDepsHash = "sha256-WeqODrueKqDFvIsXHlzWhHSdqPY/uS+VM+wCp69LN9M=";

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
