{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lintspec";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${version}";
    hash = "sha256-pZ9fq8bVZs7ihWeYyM4vDthpASXFS0U9b/F8NVkvHTA=";
  };

  cargoHash = "sha256-eZct2zpnh07Fazd34rUcAxAWfMJYkwq8nWNfpG8gFak=";

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
