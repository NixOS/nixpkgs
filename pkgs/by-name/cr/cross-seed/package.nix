{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.11.0";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-+bIRLoiY9+23GUuKxPpKK23cb4Dng5nwxh3SUzMAtXA=";
  };

  npmDepsHash = "sha256-gNsD6+4+PIcygL/QCznecd5bVnLyorVJfHM/+cLG4og=";

  passthru.tests.cross-seed = nixosTests.cross-seed;

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
