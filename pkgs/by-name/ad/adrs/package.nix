{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "adrs";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    rev = "v${version}";
    hash = "sha256-a1vxo2Zw2fvCJeGaatNqf2h74t7pvWppYS2l2gbCF5k=";
  };

  cargoHash = "sha256-eVADcCXf6hl9o9pApp3inU7kZAKA3k5mM3+vy7cq5u8=";

  meta = {
    description = "Command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/joshrotenberg/adrs";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "adrs";
  };
}
