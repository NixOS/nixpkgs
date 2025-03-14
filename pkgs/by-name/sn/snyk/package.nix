{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  snyk,
  nodejs_20,
}:

let
  version = "1.1296.0";
in
buildNpmPackage {
  pname = "snyk";
  inherit version;

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-y3S4qQ/zf28YvI0bfxNr1l521vF6Z8rmh4nuxN4z7DA=";
  };

  npmDepsHash = "sha256-rNvPOLI9FhDlnVorjaCvJKw++TYQZ6Z52yZwV13h37U=";

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
