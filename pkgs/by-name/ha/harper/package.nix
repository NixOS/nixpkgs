{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-phwFwrRuMPWPaPKi41G/YQfiRWFfNCir9478VrGckWI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sbEky7mRPq7p9W+TXYE+3vGoZXP4NuC9dec3rTIxBPI=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
