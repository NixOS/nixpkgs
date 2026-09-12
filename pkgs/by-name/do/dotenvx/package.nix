{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "dotenvx";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "dotenvx";
    repo = "dotenvx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cvIblWPNhJPah8nWrJqHAwawQ9C8EueB0leF+miOIH0=";
  };

  npmDepsHash = "sha256-5dhLX6yWdQlS5XHF3Evbk5xbD87HJEiMRDdHTstzfWw=";

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
