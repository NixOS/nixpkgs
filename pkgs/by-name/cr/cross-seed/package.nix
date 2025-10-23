{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.13.5";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-WdKd20vzJfWvnZKBID6IzXOScrZgPKDDafzT2PY9N9k=";
  };

  npmDepsHash = "sha256-iTho+dbJAt7B2R+dN2xo6jnRo/psjQE76GHYksoojdA=";

  passthru = {
    updateScript = nix-update-script;
    tests.cross-seed = nixosTests.cross-seed;
  };

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
