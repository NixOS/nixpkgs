{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "dotenvx";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eDwnuwL+rJiUGV8+Q6zm7ADnSF9WKquu55GJDocDLRA=";
  };

  npmDepsHash = "sha256-MpGKkyj0UdvyjImH04NhNWgZ2POFIf7pzSkxkgglrp4=";

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
