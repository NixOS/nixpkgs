{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "pest-ide-tools";
  version = "0.13.2";

  cargoHash = "sha256-KNYQYvklDqn0J82LAbK/zwhvyMhZJ9PMWo0rErDsIMs=";

  src = fetchFromGitHub {
    owner = "pest-parser";
    repo = "pest-ide-tools";
    rev = "v${version}";
    sha256 = "sha256-vex/l112dtBrAa/bVjLAWoPRaS82At5p76DD1f6bt3g=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "IDE support for Pest, via the LSP";
    homepage = "https://pest.rs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "pest-language-server";
  };
}
