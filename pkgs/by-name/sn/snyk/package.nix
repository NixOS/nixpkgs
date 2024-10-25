{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  testers,
  snyk,
}:

let
  version = "1.1294.0";
in
buildNpmPackage {
  pname = "snyk";
  inherit version;

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-AO36b3VWdklfMjSEE3JMZUVS1KmBSra2xX6hqlf3OUM=";
  };

  npmDepsHash = "sha256-xGRmZyDXZVuFdpT1LcSLBh9bY86rOjGvVjyCt9PSigg=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "1.0.0-monorepo"' '"version": "${version}"'
  '';

  env.NIX_CFLAGS_COMPILE =
    # Fix error: no member named 'aligned_alloc' in the global namespace
    lib.optionalString (
      stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
    ) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

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
