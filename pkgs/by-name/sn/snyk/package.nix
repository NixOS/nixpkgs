{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  npm-lockfile-fix,
  testers,
  snyk,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "snyk";
  version = "1.1309.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4lsf6JZj+HoBZ5JlZPrIUvjJ2sa01hxS2fCwtGat79g=";

    # TODO: Remove once https://github.com/snyk/cli/pull/6924 is released.
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsFetcherVersion = 2;

  npmDepsHash = "sha256-6mUScBliM4Srt/qLAOgMu4Lr6TvN9/ybQRSRxFZap1o=";

  nodejs = nodejs_24;

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "1.0.0-monorepo"' '"version": "${finalAttrs.version}"'
  '';

  postInstall = ''
    # Remove dangling symlinks created during installation (remove -delete to just see the files, or -print '%l\n' to see the target
    find -L $out -type l -print -delete
  '';

  npmBuildScript = "build:prod";

  passthru.tests.version = testers.testVersion {
    package = snyk;
  };

  meta = {
    description = "Scans and monitors projects for security vulnerabilities";
    homepage = "https://snyk.io";
    changelog = "https://github.com/snyk/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "snyk";
  };
})
