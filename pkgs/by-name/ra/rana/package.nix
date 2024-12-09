{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rana";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "grunch";
    repo = "rana";
    rev = "refs/tags/v${version}";
    hash = "sha256-gzyjOCGh45zEJvc0xFkp8gAH9Kxwfc2oPeMzbrTjnk8=";
  };

  cargoHash = "sha256-+3QbqAGQzGT4yuGPHmT2BJkcnNmwhLTpQERTl4Ri2bk=";

  meta = {
    description = "Nostr public key mining tool";
    homepage = "https://github.com/grunch/rana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jigglycrumb ];
    mainProgram = "rana";
  };
}
