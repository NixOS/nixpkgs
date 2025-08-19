{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.13.1";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-9esKfc2TuJtMPWF9JV7ML8udjVkcIIU7pN+eOsvg2Z4=";
  };

  npmDepsHash = "sha256-fxeFLcfRSHMMLoay/MiiX2wwJPF+XhoAUFnQvxnlvqA=";

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
