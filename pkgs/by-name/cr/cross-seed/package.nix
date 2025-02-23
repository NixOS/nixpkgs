{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.11.1";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    tag = "v${version}";
    hash = "sha256-ZyagXbbYUZA2CfoqVh0pmKt91kTLUGB8hUItgHbPb2w=";
  };

  npmDepsHash = "sha256-hSiGnw3Fo//oTONBmtuv0sDvldCzs1PsdImxdGWEpMo=";

  passthru.updateScript = nix-update-script;

  meta = {
    description = "Fully-automatic torrent cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
