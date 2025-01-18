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
    tag = "v${version}";
    hash = "sha256-gzyjOCGh45zEJvc0xFkp8gAH9Kxwfc2oPeMzbrTjnk8=";
  };

  cargoHash = "sha256-+3QbqAGQzGT4yuGPHmT2BJkcnNmwhLTpQERTl4Ri2bk=";

  meta = with lib; {
    description = "Nostr public key mining tool";
    homepage = "https://github.com/grunch/rana";
    license = licenses.mit;
    maintainers = with maintainers; [ jigglycrumb ];
    mainProgram = "rana";
  };
}
