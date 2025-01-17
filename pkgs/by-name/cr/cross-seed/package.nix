{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.8.5";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-PrpS4GzGkicfN04yqGDeFZBVk0RA5RFlZPbNVHpNN8E=";
  };

  npmDepsHash = "sha256-xX0su3q31R42m8jksF2IoSZCe9dFjUlrvaI5uMD/HGQ=";

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
