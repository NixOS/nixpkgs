{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  snyk,
  nodejs_20,
}:

let
  version = "1.1301.2";
in
buildNpmPackage {
  pname = "snyk";
  inherit version;

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-dyP9KywtwXYHkKDrCeNwJbZbhhIQdwYzk2GAY2+CEWM=";
  };

  npmDepsHash = "sha256-HBMOqFi3lvvVdPA+sx54Vj3cUQCV802SiWWR3+cq9Qo=";

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
