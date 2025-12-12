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

  cargoHash = "sha256-YOit8z1GAUmPz56M5jXA2EdyN5Pbo7517W3PNXgQnDs=";

  meta = {
    description = "Nostr public key mining tool";
    homepage = "https://github.com/grunch/rana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jigglycrumb ];
    mainProgram = "rana";
  };
}
