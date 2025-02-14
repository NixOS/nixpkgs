{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.9.1";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-BZ4uLPKSLtkERNUJ6PY2+djU8r8xM8vaXerfdGmYQq0=";
  };

  npmDepsHash = "sha256-hqQi0kSPm9SKEoLu6InvRMPxbQ+CBpKVPJhhOdo2ZII=";

  passthru.tests.cross-seed = nixosTests.cross-seed;

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
