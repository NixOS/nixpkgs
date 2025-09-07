{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lintspec";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${version}";
    hash = "sha256-XpwKQM6CqdRZZKdrCl6B3XlFMwKMfxBRjqfcjb9IMqQ=";
  };

  cargoHash = "sha256-8L+C3bBvKPMuEOKz6v0aKFmXgA3Z8/Sw0ugElN0mfEk=";

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
