{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  snyk,
  nodejs_20,
}:

let
  version = "1.1297.2";
in
buildNpmPackage {
  pname = "snyk";
  inherit version;

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-guDCwLvl5cYzeZJbwOQvzCuBtXo3PNrvOimS2GmQwaY=";
  };

  npmDepsHash = "sha256-SzrBhY7iWGlIPNB+5ROdaxAlQSetSKc3MPBp+4nNh+o=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "1.0.0-monorepo"' '"version": "${version}"'
  '';

  postInstall = ''
    # Remove dangling symlinks created during installation (remove -delete to just see the files, or -print '%l\n' to see the target
    find -L $out -type l -print -delete
  '';

  nodejs = nodejs_20;

  npmBuildScript = "build:prod";

  passthru.tests.version = testers.testVersion {
    package = snyk;
  };

  meta = {
    description = "Scans and monitors projects for security vulnerabilities";
    homepage = "https://snyk.io";
    changelog = "https://github.com/snyk/cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "snyk";
  };
}
