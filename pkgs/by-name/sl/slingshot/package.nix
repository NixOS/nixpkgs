{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "slingshot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "caio-ishikawa";
    repo = "slingshot";
    rev = "v${version}";
    hash = "sha256-XI6uf54sEJ0htfY43aF8/X1/OF9m6peHUGDS+2nK3xA=";
  };

  cargoHash = "sha256-NZyO6oXmgTUszp2Vc9iVAnCvM78/BJ8IfpeTrsOMvlo=";

  meta = with lib; {
    description = "Lightweight command line tool to quickly navigate across folders";
    homepage = "https://github.com/caio-ishikawa/slingshot";
    changelog = "https://github.com/caio-ishikawa/slingshot/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "slingshot";
  };
}
