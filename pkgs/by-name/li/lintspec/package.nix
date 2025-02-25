{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lintspec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${version}";
    hash = "sha256-qxr3gRJx7n11KJ09lMDUhvgMXh79DNeG7NYNFe1qYRY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qn7Z99wEGiR79vDj6Zpr+TLw6FTgL/ka9YIei66cOds=";

  meta = {
    description = "Blazingly fast linter for NatSpec comments in Solidity code";
    homepage = "https://github.com/beeb/lintspec";
    changelog = "https://github.com/beeb/lintspec/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "lintspec";
  };
}
