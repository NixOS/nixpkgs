{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.8.4";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-R0mgrRWb9pM7DWC4Y5cASkuwWBJAtk6iKz2tIa5rLVE=";
  };

  npmDepsHash = "sha256-1xP0KwuVZMeIxg3dXd0CAGW0517i/6WBu3qGOkwsoks=";

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
