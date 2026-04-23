{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.13.6";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-E2tnlDU2/msNcSsoDXvwGWFhWpXEByloUmlVp2tckwo=";
  };

  npmDepsHash = "sha256-tR7zPoIX6yjlRx8QbRSxskvueQ1BsP3gGAlonKHH0RY=";

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
