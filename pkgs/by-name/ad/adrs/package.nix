{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adrs";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-enUoRwEEn97W9j4mLxzGI9C1WRWNmOJ+AQXS3kWuD3w=";
  };

  cargoHash = "sha256-kPTA4pH/mXY02hs0XLi8zGR1hNaFiF6VoSprDlqrmpA=";

  meta = {
    description = "Command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/joshrotenberg/adrs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "adrs";
  };
})
